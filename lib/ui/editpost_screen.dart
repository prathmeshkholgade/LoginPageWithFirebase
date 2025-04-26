import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/ui/home_screen.dart';
import 'package:loginpage/utils/utils.dart';

class EditpostScreen extends StatefulWidget {
  final String id;
  final String currTitle;
  const EditpostScreen({super.key, required this.id, required this.currTitle});
  @override
  State<EditpostScreen> createState() => EditpostScreenState();
}

class EditpostScreenState extends State<EditpostScreen> {
  var editController = TextEditingController();
  bool loading = false;
  CollectionReference ref = FirebaseFirestore.instance.collection("users");
  @override
  void initState() {
    super.initState();
    editController.text = widget.currTitle;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Post")),
      body: Padding(
        padding: EdgeInsets.all(21),
        child: Column(
          children: [
            TextField(controller: editController),
            TextButton(
              onPressed: () {
                setState(() {
                  loading = true;
                });
                ref
                    .doc(widget.id)
                    .set({"title": editController.text, "id": widget.id})
                    .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().showToastMsg("post updated");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(name: "anu"),
                        ),
                      );
                    })
                    .onError((e, stk) {
                      setState(() {
                        loading = false;
                      });
                      Utils().showToastMsg(e.toString());
                    });
              },
              child: loading ? CircularProgressIndicator() : Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
