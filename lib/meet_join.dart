import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:near_voice/home.dart';
import 'package:near_voice/home.dart';
import 'package:near_voice/sound_stream.dart';
import 'package:near_voice/users_connected.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';

var ipRetrieve = ipEnter;
// var ipTest = '192.168.71.10';

class MeetJoin extends StatefulWidget {
  final String data;

  MeetJoin({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _MeetJoinState createState() => _MeetJoinState();
}

class _MeetJoinState extends State<MeetJoin> {

  List<String> messageList = [];

  RecorderStream _recorder = RecorderStream();
  PlayerStream _player = PlayerStream();

  bool _isRecording = false;
  bool _isPlaying = false;

  StreamSubscription _recorderStatus;
  StreamSubscription _playerStatus;
  StreamSubscription _audioStream;

  // final channel = IOWebSocketChannel.connect(_SERVER_URL);
  final channel = IOWebSocketChannel.connect("ws://${ipRetrieve}:8888");
  final channelTwo = IOWebSocketChannel.connect("ws://${ipRetrieve}:8888");

  // final channel = IOWebSocketChannel.connect("ws://192.168.71.10:8888");

  @override
  void initState() {
    super.initState();

    initPlugin();
    print("ip retrieve: $ipRetrieve");
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

      // channel.sink.add('ip client joined : ${ipPhone}'); //send ip to server
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
              'Connected',
              style: TextStyle(color: Colors.white70,fontSize: 25),
            ),
          ),
          backgroundColor: HexColor('#006059'),
        ),
        body: Container(
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
                  Text("client: $ipPhone"),
                  RaisedButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/users');
                      channelTwo.sink.add('user j: $ipPhone');
                      // setState(() {
                      //   channelTwo.sink.add('u : $ipPhone');
                      // });
                    },
                    child: Text('show users'),
                  ),
                ],
              ),
              Text(
                widget.data,
                style: TextStyle(fontSize: 20),
              ),
              // Expanded(
              //     child: StreamBuilder(
              //       stream: channel.stream,
              //       builder: (context, snapshot){
              //         if(snapshot.hasData){
              //           messageList.add(snapshot.data);
              //         }
              //         return getMessageList();
              //       },
              //     )
              // ),
              // Container(height: 550, child: UserConnected()),
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
                      size: 60,
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
                      size: 60,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // ),
      ),
    );
  }

  ListView getMessageList() {
    List<Widget> listWidget = [];

    for (String message in messageList) {
      listWidget.add(
        ListTile(
          title: Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                message,
                style: TextStyle(fontSize: 20),
              ),
            ),
            color: Colors.teal[50],
            height: 60,
          ),
        ),
      );
      // };
    }
    return ListView(
      children: listWidget,
    );
  }
}
