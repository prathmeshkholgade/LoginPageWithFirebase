import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loginpage/auth/signup_screen.dart';

class Splashscreen extends StatefulWidget {
  @override
  State<Splashscreen> createState() => SplashscreenState();
}

class SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignupScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Text("welcome..", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
