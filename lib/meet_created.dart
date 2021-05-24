import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:near_voice/home.dart';
import 'package:near_voice/users_connected.dart';
import 'dart:io';

// import 'package:near_voice/main.dart';
import 'main.dart';
import 'package:near_voice/sound_stream.dart';
import 'package:web_socket_channel/io.dart';
import 'package:hexcolor/hexcolor.dart';

// const _PORT = 8888;
// const _SERVER_URL = 'ws://192.168.71.10:8888';
// var ipPhone;

class MeetCreated extends StatefulWidget {
  final String data;

  MeetCreated({Key key, @required this.data}) : super(key: key);

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

  // final channel = IOWebSocketChannel.connect(_SERVER_URL);
  final channel = IOWebSocketChannel.connect("ws://${ipPhone}:8888");

  @override
  void initState() {
    super.initState();
    initPlugin();
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
      // channel.sink.add('ip server; $ipPhone');
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

  bool selected = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(
            child: Text(
              'Created',
              style: TextStyle(color: Colors.white70, fontSize: 25),
            ),
          ),
          backgroundColor: HexColor('#006059'),
        ),
        body: Container(
          padding: EdgeInsets.all(0.0),
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('assets/nearvoicefont.jpg'),
          //         fit: BoxFit.cover)
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("server: $ipPhone"),
                  RaisedButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/users');
                      channel.sink.add('user c: $ipPhone');
                    },
                    child: Text('show users'),
                  ),
                ],
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: HexColor('#e7ece6'),
                      child: UserConnected(),
                    ),
                  ),

              ),

              Container(
                color: HexColor('#006059'),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 50,
                      color: Colors.white70,
                    ),
                    // GestureDetector(
                    //   onTapDown: (tap) {
                    //     _startRecord();
                    //   },
                    //   onTapUp: (tap) {
                    //     _stopRecord();
                    //   },
                    //   onTapCancel: () {
                    //     _stopRecord();
                    //   },
                    //   child: Icon(
                    //     _isRecording ? Icons.mic_off : Icons.mic,
                    //     size: 60,
                    //     color: Colors.white70,
                    //   ),
                    // ),
                    IconButton(
                      icon: Icon(
                        selected ? Icons.mic_off : Icons.mic,
                        size: 50,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          selected = !selected;
                          if (selected) {
                            print('muted');
                            _stopRecord();
                          } else {
                            print('talking');
                            _startRecord();
                          }
                        });
                      },
                    ),
                    Icon(
                      Icons.volume_mute,
                      size: 50,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
