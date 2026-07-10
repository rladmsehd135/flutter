import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // .env 로드 후 앱 시작
  runApp(TestMap2());
}

class TestMap2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapCtrl;
  LatLng? _initPosition;
  Set<Marker> _markers = {};

  // .env에서 키 읽기 — .env 파일의 키 이름과 똑같아야 함!
  final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initPosition = LatLng(position.latitude, position.longitude);
      _markers.add(Marker(
        markerId: MarkerId('1'),
        position: _initPosition!,
        icon: BitmapDescriptor.defaultMarker,
      ));
      _fetchNearbyPlaces(position.latitude, position.longitude);
    });
  }

  Future<void> _fetchNearbyPlaces(double latitude, double longitude) async {
    Dio dio = Dio();

    // Google Places API 호출 (키는 .env에서)
    String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=restaurant&key=$apiKey";

    try {
      Response response = await dio.get(url);
      List<dynamic> results = response.data['results'];
      Map<String, dynamic> map = {};
      for (int i = 0; i < results.length; i++) {
        map = results[i];
        double lat = map['geometry']['location']['lat'];
        double lng = map['geometry']['location']['lng'];
        String name = map['name'];

        _markers.add(Marker(
          markerId: MarkerId(name),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ));
      }
      setState(() {});
    } catch (e) {
      print("Error fetching nearby places: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google 지도'),
      ),
      body: _initPosition == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapCtrl = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: _initPosition!,
          zoom: 14,
        ),
        markers: _markers,
      ),
    );
  }
}