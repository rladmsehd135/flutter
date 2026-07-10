// lib/main.dart
// 땡그랑 - 땡코치 연동 검증용 테스트 화면
// 목적: Flutter <-> Ollama(ddaengcoach) 통신이 뚫리는지 확인하는 미니 앱.
// 본 프로젝트 시작하면 ai_service.dart만 그대로 가져가면 됨.

import 'package:flutter/material.dart';
import 'services/ai_service.dart';

void main() => runApp(const DdaengTestApp());

class DdaengTestApp extends StatelessWidget {
  const DdaengTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '땡코치 연동 테스트',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6BFF)),
        useMaterial3: true,
      ),
      home: const CoachTestScreen(),
    );
  }
}

class CoachTestScreen extends StatefulWidget {
  const CoachTestScreen({super.key});

  @override
  State<CoachTestScreen> createState() => _CoachTestScreenState();
}

class _CoachTestScreenState extends State<CoachTestScreen> {
  final _ai = AiService();
  CoachTone _tone = CoachTone.ddaengjeon;
  String _result = '버튼을 눌러 땡코치를 호출해보세요.';
  bool _loading = false;
  Duration? _elapsed;

  // 테스트용 더미 집계 데이터 (본 프로젝트에서는 sqflite 집계 결과가 들어갈 자리)
  static const _naggingData =
      "커피비: 152,000원 (전월 대비 +47%), 커피비 중 '스트레스' 태그 비율: 66%";
  static const _parseData =
      'KB국민카드 승인 은*동 12,500원 일시불 07/10 14:32 스타벅스강남점';

  Future<void> _run(Future<String> Function() task) async {
    setState(() {
      _loading = true;
      _result = '땡코치 호출 중... (첫 호출은 모델 로딩 때문에 오래 걸릴 수 있어요)';
    });
    final sw = Stopwatch()..start();
    try {
      final r = await task();
      sw.stop();
      setState(() {
        _result = r;
        _elapsed = sw.elapsed;
      });
    } catch (e) {
      sw.stop();
      setState(() {
        _result = '오류: $e\n\n체크리스트:\n'
            '1. PC에서 Ollama 실행 중인가? (ollama list)\n'
            '2. 에뮬레이터인가? (실폰이면 ai_service.dart의 IP 교체)\n'
            '3. cleartextTraffic 설정했는가?\n'
            '4. 방화벽 11434 허용했는가?';
        _elapsed = sw.elapsed;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('땡코치 연동 테스트'),
        backgroundColor: const Color(0xFF0D2247),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 톤 선택
            SegmentedButton<CoachTone>(
              segments: const [
                ButtonSegment(value: CoachTone.ddaengpun, label: Text('😇 땡푼이')),
                ButtonSegment(value: CoachTone.ddaengddaeng, label: Text('😏 땡땡이')),
                ButtonSegment(value: CoachTone.ddaengjeon, label: Text('😈 땡전이')),
              ],
              selected: {_tone},
              onSelectionChanged: (s) => setState(() => _tone = s.first),
            ),
            const SizedBox(height: 16),

            // 테스트 버튼들
            FilledButton.icon(
              onPressed: _loading
                  ? null
                  : () => _run(() => _ai.generateNagging(_tone, _naggingData)),
              icon: const Icon(Icons.campaign),
              label: const Text('잔소리 생성 테스트'),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: _loading
                  ? null
                  : () => _run(() async {
                final p = await _ai.parseExpense(_parseData);
                return p == null
                    ? '파싱 실패 (미분류 처리 대상)'
                    : '파싱 성공!\n$p';
              }),
              icon: const Icon(Icons.receipt_long),
              label: const Text('카드알림 파싱 테스트'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _loading
                  ? null
                  : () => _run(() => _ai.consult(
                _tone,
                '컴퓨터 100만원인데 살까 말까?',
                '쇼핑 예산 잔액: 41,200원 / 300,000원 (사용률 87%)',
              )),
              icon: const Icon(Icons.chat_bubble_outline),
              label: Text('살까말까 상담 (남은 횟수 ${_ai.consultRemaining}회)'),
            ),
            const SizedBox(height: 20),

            // 결과 표시
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_loading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: LinearProgressIndicator(),
                        ),
                      Text(_result, style: const TextStyle(fontSize: 15, height: 1.6)),
                      if (_elapsed != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          '응답 시간: ${(_elapsed!.inMilliseconds / 1000).toStringAsFixed(1)}초',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}