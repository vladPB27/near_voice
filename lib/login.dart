import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// import 'package:near_voice/main.dart';
import 'main.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final myController = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(60),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/login.jpg'),
              fit: BoxFit.cover
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('nearvoice'),
              Text('connect your voice'),
              TextField(
                controller: myController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(), hintText: 'Name'),
              ),
              TextField(
                controller: myController2,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(), hintText: 'Status'),
              ),
              RaisedButton(
                child: Text('Log in'),
                color: Colors.blueGrey,
                textColor: Colors.white,
                onPressed: () {
                  final name = myController.text;
                  Navigator.of(context).pushNamed('/home', arguments: name);
                },
                // onPressed: () => Navigator.pushNamed(context, "Home2"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
