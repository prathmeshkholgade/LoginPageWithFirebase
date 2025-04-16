import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  const HomeScreen({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
        automaticallyImplyLeading: false,
      ),
      body: Column(children: [Text(name)]),
    );
  }
}
