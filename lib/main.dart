
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Location/currentposition.dart';
import 'package:untitled/Location/getlocation.dart';
import 'package:untitled/Location/googlemaps.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MaterialApp(
    routes: {
      '/':(context)=>Getlocation(),
      '/1':(context)=>Currentposition()
    },
  ));
}