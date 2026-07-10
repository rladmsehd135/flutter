  import 'package:flutter/material.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
  import 'package:geolocator/geolocator.dart';

  void main() => runApp(const TestMap());

  class TestMap extends StatelessWidget {
    const TestMap({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return const MaterialApp(
        home: MapScreen(),
      );
    }
  }

  class MapScreen extends StatefulWidget {
    const MapScreen({Key? key}) : super(key: key);

    @override
    _MapScreenState createState() => _MapScreenState();
  }

  class _MapScreenState extends State<MapScreen> {
    late GoogleMapController mapCtrl;
    LatLng? _initPosition;
    String? _errorMessage; // 에러 상태를 보여줄 변수 추가

    @override
    void initState() {
      super.initState();
      _getCurrentLocation();
    }

    Future<void> _getCurrentLocation() async {
      bool serviceEnabled;
      LocationPermission permission;

      try {
        // 1. 스마트폰의 위치 서비스(GPS)가 켜져 있는지 확인
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          setState(() {
            _errorMessage = '스마트폰의 위치 서비스(GPS)를 켜주세요.';
          });
          return;
        }

        // 2. 현재 앱의 권한 상태 확인
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          // 권한이 없다면 요청
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            setState(() {
              _errorMessage = '위치 권한이 거부되었습니다.';
            });
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          setState(() {
            _errorMessage = '위치 권한이 영구적으로 거부되었습니다. 설정에서 허용해주세요.';
          });
          return;
        }

        // 3. 모든 예외를 통과했다면 실제 위치 가져오기
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        setState(() {
          _initPosition = LatLng(position.latitude, position.longitude);
        });

      } catch (e) {
        setState(() {
          _errorMessage = '위치 정보를 가져오는 중 오류가 발생했습니다.';
        });
      }
    }

    @override
    void dispose() {
      mapCtrl.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('현재 위치 지도'),
        ),
        // 에러가 있으면 에러 메시지를, 위치가 아직 없으면 로딩을, 위치를 찾았으면 지도를 보여줌
        body: _errorMessage != null
            ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
            : _initPosition == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
          onMapCreated: (controller) {
            mapCtrl = controller; // 불필요한 setState 제거
          },
          initialCameraPosition: CameraPosition(
            target: _initPosition!,
            zoom: 15.0,
          ),
          myLocationEnabled: true, // 내 위치에 파란색 점 표시
          myLocationButtonEnabled: true, // 우측 상단 내 위치로 이동 버튼 활성화
        ),
      );
    }
  }
