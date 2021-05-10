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

// Change this URL to your own
// const _PORT = 8888;
// const _SERVER_URL = 'ws://192.168.71.10:8888';
// const _SERVER_URL = 'ws://192.168.1.22:8888';

// const _SERVER_URL = 'ws://192.168.71.10:8888';
var ipPhone;

void main() {
  runApp(MyApp());
  // runApp(Home());
  // runApp(Login());
  // runApp(MaterialApp(
  //   home: InitialPage(),
  // ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'nearvoice',
  //     // theme: ThemeData(
  //     //   primarySwatch: Colors.lightGreen,
  //     // ),
  //     initialRoute: '/',
  //     onGenerateRoute: RouteGenerator.generateRoute,
  //   );
  // }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nearvoice',
      // theme: ThemeData(
      //   primarySwatch: Colors.lightGreen,
      // ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

void showText() {
  print('test of a function');
}

