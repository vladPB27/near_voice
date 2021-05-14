import 'dart:async';
import 'package:flutter/material.dart';
import 'package:near_voice/home.dart';
import 'package:near_voice/login.dart';
import 'package:near_voice/route_generator.dart';

import 'dart:io';

// import 'package:sound_stream/sound_stream.dart';
import 'package:near_voice/sound_stream.dart';
import 'package:web_socket_channel/io.dart';
import 'package:hexcolor/hexcolor.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'nearvoice',
      // theme: ThemeData(
      //   primarySwatch: Colors.lightGreen,
      // ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

