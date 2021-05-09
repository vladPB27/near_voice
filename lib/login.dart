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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     'LOGIN',
        //     style: TextStyle(color: Colors.lightGreenAccent),
        //   ),
        //   backgroundColor: HexColor('#006059'),
        // ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/app-02-login.jpg'),
                  fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                child: Text('Log in'),
                color: Colors.blueGrey,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushNamed('home');
                  },
                // onPressed: () => Navigator.pushNamed(context, "Home2"),

              )
            ],
          ),
        ),
      ),
    );
  }
}
