
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class Currentposition extends StatefulWidget {
  const Currentposition({Key? key}) : super(key: key);

  @override
  State<Currentposition> createState() => _CurrentpositionState();
}

class _CurrentpositionState extends State<Currentposition> {
  late GoogleMapController googleMapController;
  static const CameraPosition initialcameraposition =
      CameraPosition(target: LatLng(32.104, 76.321), zoom: 14.0);
  Set<Marker> markers = {};
  String address='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        initialCameraPosition: initialcameraposition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();
          googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude,),zoom: 14)));
         // var about=position.latitude;
          getstreetname(position);
          markers.clear();
          markers.add( Marker(markerId:const MarkerId('cuurentLocation'),position: LatLng(position.latitude, position.longitude)));
          DatabaseReference db= FirebaseDatabase.instance.ref();
          db.child('Data/Locations').set({'Location':'${address}'});
          setState((){});
        },
        label: Text('Curent Location'),
        icon: Icon(Icons.location_on),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location service is disabled');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('Location Service Denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location services are denied permanently');
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
  Future<void> getstreetname(Position position)async {
    List<Placemark> placemark=await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place=placemark[0];
    address='${place.country},${place.locality},${place.administrativeArea},${place.subLocality},${place.thoroughfare}';

    print(placemark);
  }
}
