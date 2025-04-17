import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/auth/login_screen.dart';
import 'package:loginpage/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  HomeScreen({super.key, required this.name});
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    _auth.signOut().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            Utils().showToastMsg("logged out succssfully");
                            return LoginScreen();
                          },
                        ),
                      ).onError((error, stack) {
                        Utils().showToastMsg(error.toString());
                      });
                    });
                  },
                  child: Text("Logout"),
                ),
              ],
            ),
          ),
          Text(name),
        ],
      ),
    );
  }
}
