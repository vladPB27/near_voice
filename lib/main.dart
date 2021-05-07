import 'dart:async';
import 'package:flutter/material.dart';

import 'dart:io';

// import 'package:sound_stream/sound_stream.dart';
import 'package:near_voice/sound_stream.dart';
import 'package:web_socket_channel/io.dart';
import 'package:hexcolor/hexcolor.dart';

// Change this URL to your own
const _PORT = 8888;
// const _SERVER_URL = 'ws://192.168.71.10:8888';
// const _SERVER_URL = 'ws://192.168.1.22:8888';

const _SERVER_URL = 'ws://192.168.71.10:8888';
var ipPhone;

void main() {
  // runApp(MyApp());
  runApp(MaterialApp(
    home: InitialPage(),
  ));
}

// Route<dynamic> generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case 'Home':
//       return MaterialPageRoute(builder: (_) => Home());
//     // case 'browser':
//     //   return MaterialPageRoute(
//     //       builder: (_) => DevicesListScreen(deviceType: DeviceType.browser));
//     // case 'advertiser':
//     //   return MaterialPageRoute(
//     //       builder: (_) => DevicesListScreen(deviceType: DeviceType.advertiser));
//     default:
//       return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(
//                 child: Text('No route defined for ${settings.name}')),
//           ));
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _networkInterface;

  RecorderStream _recorder = RecorderStream();
  PlayerStream _player = PlayerStream();

  bool _isRecording = false;
  bool _isPlaying = false;

  StreamSubscription _recorderStatus;
  StreamSubscription _playerStatus;
  StreamSubscription _audioStream;

  final channel = IOWebSocketChannel.connect(_SERVER_URL);
  // final channel = IOWebSocketChannel.connect("ws://${ipPhone}:8888");

  @override
  void initState() {
    super.initState();

    // _runServer();

    initPlugin();
    // printIps();

    ///ip address
    NetworkInterface.list(includeLoopback: false, type: InternetAddressType.any)
        .then((List<NetworkInterface> interfaces) {
      setState(() {
        _networkInterface = "";
        interfaces.forEach((interface) {
          // _networkInterface += "### name: ${interface.name}\n";
          _networkInterface;
          int i = 0;
          ipPhone = interface.addresses;
          var ipPhones = interface.name;
          print("ip gotten: $ipPhone");
          print("ip name: $ipPhones");
          interface.addresses.forEach((address) {
            _networkInterface += "${i++}) ${address.address}\n";
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _recorderStatus?.cancel();
    _playerStatus?.cancel();
    _audioStream?.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    channel.stream.listen((event) async {
      print(event);
      if (_isPlaying) _player.writeChunk(event);
    });

    _audioStream = _recorder.audioStream.listen((data) {
      channel.sink.add(data);
    });

    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    _playerStatus = _player.status.listen((status) {
      if (mounted)
        setState(() {
          _isPlaying = status == SoundStreamStatus.Playing;
        });
    });

    await Future.wait([
      _recorder.initialize(),
      _player.initialize(),
    ]);
  }

  ///ip address
  // Future printIps() async {
  //   for (var interface in await NetworkInterface.list()) {
  //     print('== Interface: ${interface.name} ==');
  //     print("ipmobile: ${interface.addresses[0]}");
  //     print("ipmobile: ${interface}");
  //     for (var addr in interface.addresses) {
  //       print(
  //           '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
  //       if(addr.address.substring(0,3) == '192') {
  //         ipPhone = addr.address;
  //         print("ip phone: ${ipPhone}");
  //       }
  //       else{
  //         print("naaaaa");
  //       }
  //     }
  //   }
  // }

  void _startRecord() async {
    await _player.stop();
    await _recorder.start();
    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecord() async {
    await _recorder.stop();
    await _player.start();
    setState(() {
      _isRecording = false;
    });
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
                  image: AssetImage('assets/nearvoicefont.jpg'),
                  fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTapDown: (tap) {
                  _startRecord();
                },
                onTapUp: (tap) {
                  _stopRecord();
                },
                onTapCancel: () {
                  _stopRecord();
                },
                child: Icon(
                  _isRecording ? Icons.mic_off : Icons.mic,
                  size: 128,
                ),
              ),
              Text("  $_networkInterface"),
              RaisedButton(
                color: Colors.lightGreen,
                textColor: Colors.white,
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home2()));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InitialPage()),
                  );
                },
                // onPressed: () => Navigator.pushNamed(context, "Home2"),
                child: Text('Back'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'example: ws://ip_address:8888'
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                    _runServer();
                  },
                  // onPressed: () => Navigator.pushNamed(context, "Home2"),
                  child: Text('Create'),
                ),
                RaisedButton(
                  color: Colors.amber,
                  textColor: Colors.white,
                  onPressed: () {

                  },
                  child: Text('join'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showText() {
  print('test of a function');
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
  HttpServer.bind('192.168.71.10', _PORT).then((HttpServer server) { //ip static
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
