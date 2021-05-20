import 'package:flutter/material.dart';
import 'package:near_voice/home.dart';
import 'package:web_socket_channel/io.dart';

var ipRetrieves = ipEnter;

class UserConnected extends StatefulWidget {
  // const UserConnected({Key key}) : super(key: key);

  final String data;

  UserConnected({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _UserConnectedState createState() => _UserConnectedState();
}

class _UserConnectedState extends State<UserConnected> {
  final TextEditingController inputController = TextEditingController();
  final channel = IOWebSocketChannel.connect("ws://${ipRetrieves}:8888");

  List<String> messageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('streaming'),
            Form(
              child: TextFormField(
                controller: inputController,
                decoration: InputDecoration(labelText: 'send message'),
              ),
            ),
            RaisedButton(
              child: Text(
                'send',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                if (inputController.text.isNotEmpty) {
                  print(inputController.text);
                  channel.sink.add(inputController.text);
                  // setState(() {
                  //   messageList.add(inputController.text);
                  // });
                  inputController.text = '';
                }
              },
            ),
            // Expanded(child: getMessageList())
            Expanded(
              child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    messageList.add(snapshot.data);
                  }
                  return getMessageList();
                },
              ),
            )
          ],
        ),
      ),
    );
    // floatingActionButton: FloatingActionButton(
    //   onPressed: _sendMessage,
    //   tooltip: 'Send message',
    //   child: Icon(Icons.send),
    // ),
  }

  void _sendMessage() {
    if (inputController.text.isNotEmpty) {
      channel.sink.add(inputController.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  ListView getMessageList() {
    List<Widget> listWidget = [];

    // for (String message in messageList) {
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
    }
    return ListView(
      children: listWidget,
    );
  }
}
