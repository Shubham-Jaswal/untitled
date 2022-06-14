import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Googlemaps extends StatefulWidget {
  const Googlemaps({Key? key}) : super(key: key);

  @override
  State<Googlemaps> createState() => _GooglemapsState();
}

class _GooglemapsState extends State<Googlemaps> {
    final Completer<GoogleMapController> _controller= Completer();
  static const CameraPosition initialposition=CameraPosition(target: LatLng(32.204,76.321),zoom: 14.0);
  static const CameraPosition targetposition=CameraPosition(target: LatLng(33.15487, 75.7869),zoom: 14.0,bearing: 192.0,tilt: 60);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        initialCameraPosition: initialposition,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },


      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        gotolake();
      }, label: Text('Go'),icon: Icon(Icons.location_on),),
    );
  }
  Future<void> gotolake()
  async {
    final GoogleMapController controller=await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(targetposition));
  }
}
