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

  final channelThird = IOWebSocketChannel.connect("ws://${ipRetrieves}:8888");

  List<String> messageList = [];

  @override
  void initState() {
    super.initState();
    print('lista mostrada');

    // initPlug();//test

    for (String m in messageList) {
      print("element: $m");
    }
  }

  Future<void> initPlug() async {
    channelThird.stream.listen((event) async {
      channelThird.sink.add("haber: $ipPhone");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Users'),
      // ),
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Users connected'),

            // Form(
            //   child: TextFormField(
            //     controller: inputController,
            //     decoration: InputDecoration(labelText: 'send message'),
            //   ),
            // ),
            // RaisedButton(
            //   child: Text(
            //     'send',
            //     style: TextStyle(fontSize: 20),
            //   ),
            //   onPressed: () {
            //     if (inputController.text.isNotEmpty) {
            //       print(inputController.text);
            //       channelThird.sink.add(inputController.text);
            //       // channelThird.sink.add('user: $ipPhone');
            //       // setState(() {
            //       //   messageList.add(inputController.text);
            //       // });
            //       inputController.text = '';
            //     }
            //   },
            // ),
            // Expanded(child: getMessageList())
            Expanded(
              child: StreamBuilder(
                stream: channelThird.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // for (var m in messageList){
                    //     if(m != messageList[0] || m != messageList[1] ){
                    //       print('no existe');
                    //       // messageList.add(snapshot.data);
                    //       messageList.add(snapshot.data);
                    //     }
                    // }
                    messageList.add(snapshot.data);
                  }
                  return getMessageList();
                },
              ),
            ),

            Form(
              child: TextFormField(
                controller: inputController,
                decoration: InputDecoration(labelText: 'send message'),
              ),
            ),
            RaisedButton.icon(
              onPressed: () {
                if (inputController.text.isNotEmpty) {
                  print(inputController.text);
                  channelThird.sink.add(inputController.text);
                  // channelThird.sink.add('user: $ipPhone');
                  // setState(() {
                  //   messageList.add(inputController.text);
                  // });
                  inputController.text = '';
                }
              },
              icon: Icon(
                Icons.play_arrow
              ),
              label: Text(''),
            ),
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

  @override
  void dispose() {
    channelThird.sink.close();
    super.dispose();
  }

  Future<ListView> getMessage() async {
    List<Widget> listWidget = [];

    // for (String message in messageList) {
    for (String message in messageList) {
      // if(message != 'sdd') {
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
