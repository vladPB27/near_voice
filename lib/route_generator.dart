import 'package:flutter/material.dart';
import 'package:near_voice/home.dart';
import 'package:near_voice/launch_screen.dart';
import 'package:near_voice/login.dart';
import 'package:near_voice/main.dart';
import 'package:near_voice/meet_created.dart';
import 'package:near_voice/meet_join.dart';
import 'package:near_voice/profile.dart';
import 'package:near_voice/users_connected.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //getting arguments passed in while calling navigator.pushnamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LaunchScreen());
      case '/home':
        // return MaterialPageRoute(builder: (_) => Login());
        return MaterialPageRoute(builder: (_) => Home(data:args));
      case '/meetcreated':
        return MaterialPageRoute(builder: (_) => MeetCreated(data: args,));
      case '/meetjoin':
        // if (args is String){
        //   return MaterialPageRoute(builder: (_) => MeetJoin(
        //     data:args,
        //   ),
        //   );
        // }
        return MaterialPageRoute(builder: (_) => MeetJoin(data:args));
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile(data:args));
      case '/users':
        return MaterialPageRoute(builder: (_) => UserConnected());
      case '/third':
        // if (args is String){
        //   return MaterialPageRoute(
        //       builder: (_) => InitialPage(
        //         data:args, //data es del la otra vista
        //       ),
        //   );
        // }
      //   return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
          child: Text('ERROR'),
      ),
      );
    });
  }
}