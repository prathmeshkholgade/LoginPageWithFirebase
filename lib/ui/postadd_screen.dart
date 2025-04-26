import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:loginpage/main.dart';
import 'package:loginpage/ui/home_screen.dart';
import 'package:universal_io/io.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loginpage/utils/utils.dart';

class PostaddScreen extends StatefulWidget {
  PostaddScreen({super.key});
  @override
  State<PostaddScreen> createState() => PostaddScreenState();
}

class PostaddScreenState extends State<PostaddScreen> {
  File? _image;
  final picker = ImagePicker();

  UploadImageWithClodinary(File imageFile) async {
    // Upload image to Cloudinary
    const cloud_Name = "dn5llhtrn";
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloud_Name/image/upload",
    );
    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = "flutter app"
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final resJson = json.decode(resStr);
      print(resJson);
      return resJson['secure_url']; // this is the image URL
    } else {
      print("Upload failed: ${response.statusCode}");
      return null;
    }
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      if (!kIsWeb && Platform.isWindows) {
        print(_image);
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print(_image);
        } else {
          print('No image selected');
        }
        print(_image);
      }
    });
  }

  bool loading = false;
  var textController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Firebase Firestore",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(hintText: "What's in your mind"),
            ),
            SizedBox(height: 20),
            Text("Upload Image"),
            InkWell(
              onTap: () => {getImage()},
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child:
                    _image != null
                        ? Image.file(_image!.absolute)
                        : Icon(Icons.image),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      String id =
                          DateTime.now().microsecondsSinceEpoch.toString();
                      String? imageUrl;
                      if (_image != null) {
                        imageUrl = await UploadImageWithClodinary(_image!);
                      }
                      fireStore
                          .doc(id)
                          .set({
                            "title": textController.text.toString(),
                            "id": id,
                            "imageUrl": imageUrl,
                          })
                          .then((value) {
                            setState(() {
                              loading = false;
                            });
                            Utils().showToastMsg("post added");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>HomeScreen(name: "prathmesh"),
                              ),
                            );
                            textController.clear();
                          })
                          .onError((error, StackTrace) {
                            Utils().showToastMsg(error.toString());
                            setState(() {
                              loading = false;
                            });
                          });
                    },
                    child: loading ? CircularProgressIndicator() : Text("Add"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
