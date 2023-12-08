import 'package:flutter/material.dart';
import 'package:meeting/LikedPerson.dart';
import 'package:meeting/chatlist.dart';
import 'package:meeting/chatlistusers.dart';
import 'package:meeting/chatscreen.dart';
import 'package:meeting/findanswer.dart';
import 'package:meeting/goodgame.dart';
import 'package:meeting/home.dart';
import 'package:meeting/login.dart';
import 'package:meeting/model/user_model.dart';
import 'package:meeting/profilecreation.dart';
import 'package:meeting/profileupdate.dart';
import 'package:meeting/signup.dart';
import 'package:meeting/testverification.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => (Home()));
      case '/signup':
        return MaterialPageRoute(builder: (_) => (SignUp()));
      case '/login':
        return MaterialPageRoute(builder: (_) => (MyLoginPage()));

      case '/profileuser':
        return MaterialPageRoute(builder: (_) => (ProfileCreation()));
      case '/chatlist':
        return MaterialPageRoute(builder: (_) => (Chatlistusers()));
      case '/chatscreen':
        return MaterialPageRoute(builder: (_) => ChatScreen(args.toString()));
      case '/profileuserupdate':
        return MaterialPageRoute(builder: (_) => ProfileUpdate());
      case '/verificationparcode':
        return MaterialPageRoute(builder: (_) => TestVerification());
      case '/likes':
        return MaterialPageRoute(builder: (_) => LikedPerson());
      case '/findanswer':
        return MaterialPageRoute(builder: (_) => FindAnswer());
      case '/goodgame':
        return MaterialPageRoute(builder: (_) => GoodGame());
        
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: const Center(
          child: Text("Error"),
        ),
      );
    });
  }
}
