import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Getlocation extends StatefulWidget {
  const Getlocation({Key? key}) : super(key: key);

  @override
  State<Getlocation> createState() => _GetlocationState();
}

class _GetlocationState extends State<Getlocation> {
  String address='';
  String offlineaddress='';
  String offlineDetailsget='';
  String offlineDetails='';
  var locationmessage = '';
  DateTime now = DateTime.now();

  Future<Position> getlocation() async {
    LocationPermission permission=await Geolocator.checkPermission();
    LocationPermission permision=await Geolocator.requestPermission();
    var position =await
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
    var lastposition = await Geolocator.getLastKnownPosition();
    //print(lastposition);
   // print(position);
    /*setState(() {
      locationmessage = '${position.latitude},  ${position.longitude}';
    });*/
    return position;
  }
  @override
  void initState()
  {
      getDetails();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 30,right: 30),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, children: [

            Text(
              '$offlineDetails',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              child: Center(
                child: Text(
                  '$address,'" "'Time:'" "'$now',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
              width: 150,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    onPrimary: Colors.black,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () async {
                    var connectivityResult = await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile) {
                      Position position = await getlocation();
                      getstreetname(position);
                      // I am connected to a mobile network.
                      Fluttertoast.showToast(msg: 'I am connected to a mobile network.');
                    } else if (connectivityResult == ConnectivityResult.wifi) {
                      Position position = await getlocation();
                      getstreetname(position);
                      // I am connected to a wifi network.
                      Fluttertoast.showToast(msg: 'I am connected to  WiFi.');
                    }
                    else{
                      Position position = await getlocation();
                      getstreetname(position);
                      offlineDetails=offlineaddress;
                      setDetails();
                      Fluttertoast.showToast(msg: 'I am not connected to a Internet.');
                    }

                  },
                  child: Text('Capture Location')),
            ),
            SizedBox(height: 30,),
            Container(
              height: 50,
              width: 150,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    onPrimary: Colors.black,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                   Navigator.pushNamed(context, '/1');
                  },
                  child: Text('GUI Version')),
            )
          ],
        ),
      ),
    );
  }
  Future<void> getstreetname(Position position)async {
    List<Placemark> placemark=await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place=placemark[0];
    address='${place.country},${place.locality},${place.administrativeArea},${place.subLocality},${place.thoroughfare}';
    offlineaddress='${place.country}';

   // print(placemark);
  }

  void getDetails() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    offlineDetailsget = pref.getString('data')!;
    print('${offlineDetailsget}');
    setState(() {});
  }
  Future<void> setDetails() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('data', offlineDetails);
    print('lol${offlineDetails}');
  }
}
