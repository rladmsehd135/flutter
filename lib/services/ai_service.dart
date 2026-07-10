// lib/services/ai_service.dart
// 땡그랑 - 땡코치 AI 서비스 (팀 공용 Ollama 서버 연동)
//
// ★★★ 팀원들에게: 이 파일에서 건드릴 곳은 아래 [서버 설정] 딱 한 줄입니다 ★★★
//
// 기능:
//  1) 잔소리/브리핑 생성 (3톤: 착한 땡푼이 / 현실적인 땡땡이 / 악마 땡전이)
//  2) 살까말까 상담 (Rate Limit: 하루 5회)
//  3) 카드 알림 -> 지출 JSON 파싱
//  4) 숫자 환각 검증 (출력 숫자가 입력에 없으면 1회 재생성)
//
// 사용 전 준비 (프로젝트에 한 번만):
//  - pubspec.yaml dependencies에  http: ^1.2.0  추가
//  - AndroidManifest.xml <application>에 android:usesCleartextTraffic="true"
//  - AndroidManifest.xml에 <uses-permission android:name="android.permission.INTERNET"/>

import 'dart:convert';
import 'package:http/http.dart' as http;


const String kAiServerIp = '192.168.30.55';
const String kAiServerPort = '11434';
// ════════════════════════════════════════════════════════════

/// 땡코치 톤
enum CoachTone {
  ddaengpun('착한 땡푼이'),
  ddaengddaeng('현실적인 땡땡이'),
  ddaengjeon('악마 땡전이');

  final String label;
  const CoachTone(this.label);
}

/// 파싱된 지출 정보
class ParsedExpense {
  final int amount;
  final String merchant;
  final String category;
  final String type; // 고정비 | 변동비

  ParsedExpense({
    required this.amount,
    required this.merchant,
    required this.category,
    required this.type,
  });

  factory ParsedExpense.fromJson(Map<String, dynamic> j) => ParsedExpense(
    amount: j['amount'] as int,
    merchant: j['merchant'] as String,
    category: j['category'] as String,
    type: j['type'] as String,
  );

  @override
  String toString() => '$merchant / $amount원 / $category / $type';
}

class AiService {
  static const String _baseUrl = 'http://$kAiServerIp:$kAiServerPort';
  static const String _model = 'ddaengcoach';

  // ── 서버 연결 체크 ─────────────────────────────────────────
  /// 앱 시작 시 or 설정 화면에서 호출. true면 AI 사용 가능 상태.
  Future<bool> isServerAlive() async {
    try {
      final res = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 3));
      return res.statusCode == 200; // "Ollama is running"
    } catch (_) {
      return false;
    }
  }

  // ── 상담 Rate Limit (하루 5회) ─────────────────────────────
  // MVP: 메모리 카운터. 본 프로젝트에서는 sqflite에 날짜별 저장으로 교체.
  static const int consultDailyLimit = 5;
  int _consultCount = 0;
  String _consultDate = '';

  int get consultRemaining {
    _resetIfNewDay();
    return consultDailyLimit - _consultCount;
  }

  void _resetIfNewDay() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (_consultDate != today) {
      _consultDate = today;
      _consultCount = 0;
    }
  }

  // ── 1) 잔소리/브리핑 ───────────────────────────────────────
  /// [dataSummary] 예: "배달비: 140,000원 (전월 대비 +40%), 스트레스 태그 비율: 70%"
  /// 계산은 반드시 앱(sqflite 집계)에서 끝내고, 완성된 숫자 문장만 넘길 것.
  Future<String> generateNagging(CoachTone tone, String dataSummary) async {
    final prompt = '[톤: ${tone.label}] $dataSummary';
    return _generateWithValidation(prompt, dataSummary);
  }

  // ── 2) 살까말까 상담 (Rate Limit) ──────────────────────────
  /// [question] 사용자 질문, [context] 예산 잔액/최근 패턴 요약
  Future<String> consult(CoachTone tone, String question, String context) async {
    _resetIfNewDay();
    if (_consultCount >= consultDailyLimit) {
      throw RateLimitException('오늘 상담 횟수를 모두 사용했어요. 내일 다시 만나요!');
    }
    _consultCount++;
    final prompt = '[톤: ${tone.label}] $context\n질문: $question';
    // 상담은 자유 질문이라 숫자 검증을 느슨하게(검증 실패해도 원문 반환)
    try {
      return await _generateWithValidation(prompt, context);
    } on NumberMismatchException catch (e) {
      return e.rawOutput;
    }
  }

  // ── 3) 카드 알림 파싱 ──────────────────────────────────────
  /// [notificationText] 예: "KB국민카드 승인 은*동 12,500원 일시불 07/09 14:32 스타벅스강남점"
  /// 반환 실패(null) 시 호출부에서 '미분류' 처리 -> 사용자 직접 입력 유도
  Future<ParsedExpense?> parseExpense(String notificationText) async {
    final raw = await _callOllama('[작업: 지출파싱] $notificationText');
    try {
      // 모델이 JSON 앞뒤에 군더더기를 붙일 경우 대비해 중괄호 구간만 추출
      final start = raw.indexOf('{');
      final end = raw.lastIndexOf('}');
      if (start == -1 || end == -1) return null;
      final parsed = ParsedExpense.fromJson(
        jsonDecode(raw.substring(start, end + 1)) as Map<String, dynamic>,
      );
      // 금액이 원문에 실제로 존재하는지 검증 (환각 방어)
      final amountStr = parsed.amount.toString();
      final amountComma = _withComma(parsed.amount);
      if (!notificationText.contains(amountStr) &&
          !notificationText.contains(amountComma)) {
        return null;
      }
      return parsed;
    } catch (_) {
      return null;
    }
  }

  // ── 내부: 생성 + 숫자 검증 (실패 시 1회 재시도) ─────────────
  Future<String> _generateWithValidation(String prompt, String source) async {
    for (var attempt = 0; attempt < 2; attempt++) {
      final output = await _callOllama(prompt);
      if (_numbersValid(output, source)) return output;
      if (attempt == 1) throw NumberMismatchException(output);
    }
    throw StateError('unreachable');
  }

  // ── 내부: Ollama API 호출 ─────────────────────────────────
  Future<String> _callOllama(String prompt) async {
    final http.Response res;
    try {
      res = await http
          .post(
        Uri.parse('$_baseUrl/api/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': _model,
          'prompt': prompt,
          'stream': false,
        }),
      )
          .timeout(const Duration(seconds: 90)); // 공용 서버 + CPU 서빙, 넉넉하게
    } catch (e) {
      throw AiServerException(
          'AI 서버에 연결할 수 없어요. 은동 PC가 켜져 있는지, 같은 와이파이인지 확인! ($e)');
    }

    if (res.statusCode != 200) {
      throw AiServerException('Ollama 응답 오류: ${res.statusCode}');
    }
    final body = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    return (body['response'] as String).trim();
  }

  // ── 내부: 숫자 검증 ────────────────────────────────────────
  // 출력에 등장한 3자리 이상 숫자가 입력(source)에 없으면 실패.
  // "14만 8천원" 같은 한국어 단위 표기는 원 단위로 복원해서 대조.
  bool _numbersValid(String output, String source) {
    final srcNums = _extractNumbers(source);
    final outNums = _extractNumbers(output);
    for (final n in outNums) {
      if (n.length >= 3 && !srcNums.contains(n)) return false;
    }
    return true;
  }

  Set<String> _extractNumbers(String text) {
    final result = <String>{};
    // 일반 숫자 (콤마 제거)
    for (final m in RegExp(r'\d[\d,]*').allMatches(text)) {
      result.add(m.group(0)!.replaceAll(',', ''));
    }
    // "N만 M천원" / "N만원" -> 원 단위 복원
    for (final m in RegExp(r'(\d+)만(?:\s*(\d+)천)?').allMatches(text)) {
      final man = int.parse(m.group(1)!);
      final cheon = int.tryParse(m.group(2) ?? '') ?? 0;
      result.add((man * 10000 + cheon * 1000).toString());
    }
    return result;
  }

  String _withComma(int n) => n.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
}

class RateLimitException implements Exception {
  final String message;
  RateLimitException(this.message);
  @override
  String toString() => message;
}

class AiServerException implements Exception {
  final String message;
  AiServerException(this.message);
  @override
  String toString() => message;
}

class NumberMismatchException implements Exception {
  final String rawOutput;
  NumberMismatchException(this.rawOutput);
  @override
  String toString() => '숫자 검증 실패';
}