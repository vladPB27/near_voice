import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:near_voice/main.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:get_ip/get_ip.dart';
import 'dart:io';

const _PORT = 8888;
var ipPhone;
var ipEnter;

class Home extends StatefulWidget {
  final String data;

  Home({Key key, @required this.data}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<Home> {
  // final String data = "";
  String _ip = "unknown";
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String ipAddress;
    try {
      ipAddress = await GetIp.ipAddress;
    } on PlatformException {
      ipAddress = 'Failed to get ipAddress';
    }

    if (!mounted) return;
    setState(() {
      _ip = ipAddress;
      ipPhone = _ip;
    });
  }

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
        // resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.white,
        // backgroundColor: HexColor("#006059"),
        body: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.lightGreenAccent,
                    size: 50.0,
                  ),
                  Text(
                    '  Hi, ${widget.data}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () {},
                  child: Image.asset('assets/png/profile-1.png'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    ///create
                    child: FlatButton(
                      onPressed: () {
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
                    labelText: "IP Address Meeting",
                    border: OutlineInputBorder(),
                    hintText: 'Enter ip address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _runServer() async {
  // for (var interface in await NetworkInterface.list()) {
  //   print('== Interface: ${interface.name} ==');
  //   print('== Interface 2: ${interface.addresses} ==');
  //   // print("ipmobile: ${interface.addresses[0]}");
  //   // print("ipmobile: ${interface}");
  //   for (var addr in interface.addresses) {
  //     print(
  //         '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
  //     if (addr.address.substring(0, 3) == '192') {
  //       ipPhone = addr.address;
  //       print("ip phone: ${ipPhone}");
  //     }
  //   }
  // }

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
