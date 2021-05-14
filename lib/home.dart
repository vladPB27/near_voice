import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:near_voice/main.dart';
import 'package:imagebutton/imagebutton.dart';
import 'dart:io';

const _PORT = 8888;
var ipPhone;
var ipEnter;

var ip = InternetAddress.ANY_IP_V4;

class Home extends StatefulWidget {
  final String data;

  Home({Key key, @required this.data}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<Home> {
  // final String data = "";
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(60),
          child: Column(
            children: [
              Text('Hi, ${widget.data}'),
              Expanded(
                  child: FlatButton(
                onPressed: () {},
                child: Image.asset('assets/png/profile-1.png'),
              )),
              Row(
                children: [
                  Expanded(
                    ///create
                    child: FlatButton(
                      onPressed: () {
                        print("my ip: $ip");
                        Navigator.of(context).pushNamed('/meetcreated',
                            arguments: 'you are the server');
                        _runServer();
                      },
                      child: Image.asset('assets/png/create-1.png'),
                    ),
                  ),
                  Expanded(
                    ///join
                    child: FlatButton(
                      onPressed: () {
                        ipEnter = myController.text;
                        print("ip enter: $ipEnter");
                        Navigator.of(context)
                            .pushNamed('/meetjoin', arguments: ipEnter);
                      },
                      child: Image.asset('assets/png/join-1.png'),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: myController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'example: ws://ip_address:8888'),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              // RaisedButton(
              //   color: Colors.lightGreen,
              //   textColor: Colors.white,
              //   onPressed: () {
              //     Navigator.of(context).pushNamed('/meetcreated',
              //         arguments: 'you are the server');
              //     _runServer();
              //   },
              //   child: Text('Create'),
              // ),
              // RaisedButton(
              //   color: Colors.amber,
              //   textColor: Colors.white,
              //   onPressed: () {
              //     ipEnter = myController.text;
              //     print("ip enter: $ipEnter");
              //     Navigator.of(context)
              //         .pushNamed('/meetjoin', arguments: ipEnter);
              //     // arguments: 'hello from home');
              //   },
              //   child: Text('join'),
              // ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

void _runServer() async {
  for (var interface in await NetworkInterface.list()) {
    print('== Interface: ${interface.name} ==');
    print('== Interface 2: ${interface.addresses} ==');
    // print("ipmobile: ${interface.addresses[0]}");
    // print("ipmobile: ${interface}");
    for (var addr in interface.addresses) {
      print(
          '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      if (addr.address.substring(0, 3) == '192') {
        ipPhone = addr.address;
        print("ip phone: ${ipPhone}");
      }
    }
  }

  final connections = Set<WebSocket>();
  // HttpServer.bind('192.168.71.10', _PORT).then((HttpServer server) {
  //ip static
  HttpServer.bind(ipPhone.toString(), _PORT).then((HttpServer server) {
    //own ip address
    print("ip phone server: $ipPhone");
    print('[+]WebSocket listening at -- ws://$ipPhone:$_PORT/');
    server.listen((HttpRequest request) {
      WebSocketTransformer.upgrade(request).then((WebSocket ws) {
        connections.add(ws);
        print('[+]Connected');
        ws.listen(
          (data) {
            // Broadcast data to all other clients
            for (var conn in connections) {
              if (conn != ws && conn.readyState == WebSocket.open) {
                conn.add(data);
              }
            }
          },
          onDone: () {
            connections.remove(ws);
            print('[-]Disconnected');
          },
          onError: (err) {
            connections.remove(ws);
            print('[!]Error -- ${err.toString()}');
          },
          cancelOnError: true,
        );
      }, onError: (err) => print('[!]Error -- ${err.toString()}'));
    }, onError: (err) => print('[!]Error -- ${err.toString()}'));
  }, onError: (err) => print('[!]Error -- ${err.toString()}'));
}
