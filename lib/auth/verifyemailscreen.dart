import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/ui/home_screen.dart';

class Verifyemailscreen extends StatefulWidget {
  const Verifyemailscreen({super.key});
  @override
  State<Verifyemailscreen> createState() => VerifyemailscreenState();
}

class VerifyemailscreenState extends State<Verifyemailscreen> {
  @override
  late Timer timer;
  var _auth = FirebaseAuth.instance;
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _auth.currentUser!.reload();
      if (_auth.currentUser!.emailVerified) {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    HomeScreen(name: _auth.currentUser!.email.toString()),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify email")),
      body: Center(
        child: Column(
          children: [
            Text("Verification link has sent to your  email"),
            SizedBox(height: 20),
            TextButton(onPressed: () {}, child: Text("Resend Email")),
          ],
        ),
      ),
    );
  }
}
