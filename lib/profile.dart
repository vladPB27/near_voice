import 'package:flutter/material.dart';
import 'package:near_voice/meet_join.dart';
import 'package:web_socket_channel/io.dart';
import 'package:near_voice/home.dart';

var ipRetrieves = ipEnter;
class Profile extends StatefulWidget {
  // const Profile({Key key}) : super(key: key);

  final String data;

  Profile ({
    Key key,
    @required this.data,
}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _controller = TextEditingController();
  final channel = IOWebSocketChannel.connect("ws://${ipRetrieves}:8888");
  // final channel = IOWebSocketChannel.connect('wss://echo.websocket.org');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot){
                return Text(snapshot.hasData ? '${snapshot.data}' : 'f');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage(){
    if(_controller.text.isNotEmpty){
      channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose(){
    channel.sink.close();
    super.dispose();
  }
}
