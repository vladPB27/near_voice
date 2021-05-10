import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:near_voice/home.dart';
import 'dart:io';
// import 'package:near_voice/main.dart';
import 'main.dart';
import 'package:near_voice/sound_stream.dart';
import 'package:web_socket_channel/io.dart';
import 'package:hexcolor/hexcolor.dart';

const _PORT = 8888;
const _SERVER_URL = 'ws://192.168.71.10:8888';
var ipPhone;

class MeetCreated extends StatefulWidget {
  @override
  _MeetCreatedState createState() => _MeetCreatedState();
}

class _MeetCreatedState extends State<MeetCreated> {
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
                          MaterialPageRoute(builder: (context) => Home()),
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