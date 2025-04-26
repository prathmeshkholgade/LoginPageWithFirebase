import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/auth/login_screen.dart';
import 'package:loginpage/ui/editpost_screen.dart';
import 'package:loginpage/ui/postadd_screen.dart';
import 'package:loginpage/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  HomeScreen({super.key, required this.name});
  final _auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  final fireStore = FirebaseFirestore.instance.collection("users").snapshots();
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
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostaddScreen()),
                  );
                },
                child: Text("AddPost"),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshots,
            ) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshots.hasError) {
                return Text("some error");
              }
              //               var postData = snapshots.data as Map<String, dynamic>;
              // var post = snapshots.data!.docs[index].data() as Map<String, dynamic>
              //               String? imageUrl = postData["imageUrl"];
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var post = snapshots.data!.docs[index];
                    String? imageUrl = post['imageUrl'];
                    print(imageUrl);

                    return Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(21),
                            child: Row(
                              children: [
                                Text(
                                  snapshots.data!.docs[index]['title']
                                      .toString(),
                                ),
                                imageUrl != null
                                    ? Image.network(
                                      imageUrl,
                                      width: 100,
                                      height: 100,
                                    )
                                    : Text('No image available'),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => EditpostScreen(
                                              id:
                                                  snapshots
                                                      .data!
                                                      .docs[index]['id'],
                                              currTitle:
                                                  snapshots
                                                      .data!
                                                      .docs[index]['title'],
                                            ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ref
                                        .doc(
                                          snapshots.data!.docs[index]["id"]
                                              .toString(),
                                        )
                                        .delete();
                                  },
                                  icon: Icon(Icons.remove, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );

                    // ListTile(
                    //   // onTap: () {
                    //   //   ref
                    //   //       .doc(snapshots.data!.docs[index]["id"].toString())
                    //   //       .update({"title": "update to title"})
                    //   //       .then((value) {
                    //   //         Utils().showToastMsg(("updated"));
                    //   //       })
                    //   //       .onError((e, stk) {
                    //   //         Utils().showToastMsg(e.toString());
                    //   //       });
                    //   // },
                    //   title: Text(
                    //     snapshots.data!.docs[index]['title'].toString(),
                    //   ),

                    //   subtitle: Text(
                    //     snapshots.data!.docs[index]["title"].toString(),
                    //   ),
                    // );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
