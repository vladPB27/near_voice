import 'package:flutter/material.dart';
import 'package:near_voice/login.dart';
import 'package:near_voice/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //getting arguments passed in while calling navigator.pushnamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Login());
      case '/home':
        return MaterialPageRoute(builder: (_) => InitialPage());
      case '/second':
        return MaterialPageRoute(builder: (_) => MyApp());
      // case '/third':
      //   if (args is String){
      //     return MaterialPageRoute(
      //         builder: (_) => InitialPage(
      //           data:args, //data es del la otra vista
      //         ),
      //     );
      //   }
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