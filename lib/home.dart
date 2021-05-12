import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:near_voice/main.dart';
import 'package:imagebutton/imagebutton.dart';
import 'dart:io';

const _PORT = 8888;
var ipPhone;
var ipEnter;

class Home extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<Home> {
  final String data = "";
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
        // backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'nearvoice',
            style: TextStyle(color: Colors.lightGreenAccent),
          ),
          backgroundColor: HexColor('#006059'),
        ),
        body: Center(
          child: Column(
            children: [

              Text('Welcome @user'),
              MaterialButton(
                padding: EdgeInsets.all(8.0),
                textColor: Colors.white,
                splashColor: Colors.greenAccent,
                elevation: 8.0,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/png/createss.png'),
                        fit: BoxFit.cover),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("SIGN OUT"),
                  ),
                ),
                // ),
                onPressed: () {
                  print('Tapped');
                },
              ),
              Expanded(child: Image.asset('assets/app-02-login.jpg',),
              ),
              Row(
                children: [
                  Expanded(child: Image.asset('assets/nearvoicefont.jpg',),
                  ),
                  Expanded(child: Image.asset('assets/png/createss.png',),
                  ),
                ],
              ),
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
                      Navigator.of(context).pushNamed('/meetcreated',
                          arguments: 'hi to created');
                      _runServer();
                    },
                    child: Text('Create'),
                  ),
                  RaisedButton(
                    color: Colors.amber,
                    textColor: Colors.white,
                    onPressed: () {
                      ipEnter = myController.text;
                      print("ip enter: $ipEnter");
                      Navigator.of(context)
                          .pushNamed('/meetjoin', arguments: ipEnter);
                      // arguments: 'hello from home');
                    },
                    child: Text('join'),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Container(
        //   ///image in the background
        //   // decoration: BoxDecoration(
        //   //     image: DecorationImage(
        //   //         image: AssetImage('assets/app-04-home.jpg'),
        //   //         fit: BoxFit.cover)
        //   // ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.stretch,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       IconButton(
        //           icon: Image.asset('assets/png/createss.png'),
        //           onPressed: () {}),
        //       Text('here comes a button'),
        //       ImageButton(
        //         children: <Widget>[],
        //         width: 91,
        //         height: 36,
        //         paddingTop: 5,
        //         pressedImage: Image.asset(
        //           "assets/png/creates.png",
        //         ),
        //         unpressedImage: Image.asset("assets/png/creates.png"),
        //         onTap: () {
        //           print('test');
        //         },
        //       ),
        //       TextField(
        //         controller: myController,
        //         decoration: InputDecoration(
        //             border: UnderlineInputBorder(),
        //             hintText: 'example: ws://ip_address:8888'),
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           RaisedButton(
        //             color: Colors.lightGreen,
        //             textColor: Colors.white,
        //             onPressed: () {
        //               Navigator.of(context).pushNamed('/meetcreated',
        //                   arguments: 'hi to created');
        //               _runServer();
        //             },
        //             child: Text('Create'),
        //           ),
        //           RaisedButton(
        //             color: Colors.amber,
        //             textColor: Colors.white,
        //             onPressed: () {
        //               ipEnter = myController.text;
        //               print("ip enter: $ipEnter");
        //               Navigator.of(context)
        //                   .pushNamed('/meetjoin', arguments: ipEnter);
        //               // arguments: 'hello from home');
        //             },
        //             child: Text('join'),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
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
  // HttpServer.bind('192.168.71.10', _PORT).then((HttpServer server) {
  //ip static
  HttpServer.bind(ipPhone.toString(), _PORT).then((HttpServer server) {
    //own ip address
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
