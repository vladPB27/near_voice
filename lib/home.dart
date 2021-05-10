import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:near_voice/main.dart';
import 'dart:io';

const _PORT = 8888;

class Home extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<Home> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'nearvoice',
            style: TextStyle(color: Colors.lightGreenAccent),
          ),
          backgroundColor: HexColor('#006059'),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/app-04-home.jpg'),
                  fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextField(
                controller: myController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'example: ws://ip_address:8888'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    color: Colors.lightGreen,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/meetcreated');
                      _runServer();
                    },
                    // onPressed: () => Navigator.pushNamed(context, "Home2"),
                    child: Text('Create'),
                  ),
                  RaisedButton(
                    color: Colors.amber,
                    textColor: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(myController.text),
                          );
                        },
                      );
                    },
                    child: Text('join'),
                  ),
                ],
              ),
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
    print("ipmobile: ${interface.addresses[0]}");
    print("ipmobile: ${interface}");
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
  HttpServer.bind('192.168.71.10', _PORT).then((HttpServer server) {
    //ip static
    // HttpServer.bind(ipPhone.toString(), _PORT).then((HttpServer server) { //own ip address
    print("ip phone server: $ipPhone");
    print('[+]WebSocket listening at -- ws://ip_address:$_PORT/');
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
