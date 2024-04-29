

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? position;
  late GoogleMapController _mapController;
  
  
  @override
  void initState() {
    super.initState();
    _initializeMapSomething();
    _listenCurrentLocator();
  }
  
  Future<void> _initializeMapSomething()async {
    print(await _mapController.getVisibleRegion());
  }

  Future<void> _onScreenStrat() async{
    bool isEnabled =await Geolocator.isLocationServiceEnabled();
    print(isEnabled);

    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      position = await Geolocator.getCurrentPosition();
    }else {
      LocationPermission requestStatus = await Geolocator.requestPermission();
      if(requestStatus == LocationPermission.whileInUse ||
          requestStatus == LocationPermission.always){
        _onScreenStrat();
      }else{
        print('Permission denied');
      }
    }
  }

  void _listenCurrentLocator() {
    Geolocator.getPositionStream(locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
        timeLimit: Duration(seconds: 3)
    )
    ).listen((p) {
      // print();
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: GoogleMap(
        mapType: MapType.satellite,
        onMapCreated: (GoogleMapController controller){
          _mapController = controller;
          _initializeMapSomething();
        },
        zoomControlsEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(23.744287065983727, 90.3841376276092),
          zoom: 17,
          bearing: 90,
          tilt: 90
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (LatLng latLng){
          print('tapped on map $latLng');
        },
        onLongPress: (LatLng latLng){
          print('on long press $latLng');
        },
        compassEnabled: true,
        zoomGesturesEnabled: true,
        //liteModeEnabled: true,
        markers: {
          Marker(
            markerId: MarkerId('My Restaurant'),
            position: LatLng(23.747237276434173, 90.38539588451385),
            infoWindow: InfoWindow(title: 'My new restaurant'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
            draggable: true,
            flat: true
          ),
          Marker(
              markerId: MarkerId('My Restaurant'),
              position: LatLng(23.747252007086058, 90.38489162921906),
              infoWindow: InfoWindow(title: 'My new restaurant'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              draggable: true,
              flat: true
          ),
          Marker(
              markerId: MarkerId('My Restaurant'),
              position: LatLng(23.7466234977913, 90.38463413715363),
              infoWindow: InfoWindow(title: 'My new restaurant'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              draggable: true,
              flat: false
          ),
        },
        circles: {
          Circle(
            circleId: CircleId('My restaurant'),
            center: LatLng(23.747237276434173, 90.38539588451385),
            radius: 50,
            strokeColor: Colors.orange,
            strokeWidth: 3,
            fillColor: Colors.orange.withOpacity(.15)
          ),
          Circle(
            circleId: CircleId('My function'),
            center: LatLng(23.74797380698723, 90.38351833820343),
            radius: 50,
            strokeColor: Colors.orange,
            strokeWidth: 3,
            fillColor: Colors.orange.withOpacity(.15),
            onTap: (){
              print('Trapped on circle');
            },
            consumeTapEvents: true

          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('play-one'),
            points: [
              LatLng(23.744549825251536, 90.38668032735586),
              LatLng(23.744477091132616, 90.38653582334518),
              LatLng(23.74369665454951, 90.38081433624029)
            ]
          )
        },
        polygons: {
          Polygon(
            polygonId: PolygonId('random id'),
            fillColor: Colors.orange,
            strokeColor: Colors.orange,
            strokeWidth: 3,
            holes: [],//todo
            points: [
              LatLng(23.744372132965363, 90.35931576043367),
              LatLng(23.74317891838095, 90.35963125526905),
              LatLng(23.742958872213677, 90.36081545054913),
              LatLng(23.743207153008694, 90.35867638885975),
              LatLng(23.744051426930255, 90.35928759723902),
              LatLng(23.743705861457425, 90.36021396517754)
            ]
          )
        },
      ),

    );
  }
}

