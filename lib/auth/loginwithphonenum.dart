import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/auth/verifycode.dart';
import 'package:loginpage/utils/utils.dart';
import 'package:loginpage/widget/round_button.dart';

class LoginWithPhoneNum extends StatefulWidget {
  @override
  State<LoginWithPhoneNum> createState() => LoginWithPhoneNumState();
}

class LoginWithPhoneNumState extends State<LoginWithPhoneNum> {
  bool loading = false;
  var phonenumcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Login")),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(21),
        child: Column(
          children: [
            SizedBox(height: 50),
            TextFormField(
              controller: phonenumcontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Phone Number"),
            ),
            SizedBox(height: 80),
            RoundButton(
              title: "Login",
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                _auth.verifyPhoneNumber(
                  phoneNumber: phonenumcontroller.text,
                  verificationCompleted: (_) {
                    setState(() {
                      setState(() {
                        loading = false;
                      });
                    });
                  },
                  verificationFailed:
                      (e) => {
                        setState(() {
                          loading = false;
                        }),
                        Utils().showToastMsg(e.toString()),
                      },
                  codeSent: (String verificationId, int? token) {
                    Utils().showToastMsg("OTP sent to your phone number");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => VerifyCodeScreen(
                              verifivationId: verificationId,
                            ),
                      ),
                    );
                    setState(() {
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout:
                      (e) => {
                        Utils().showToastMsg(e.toString()),
                        setState(() {
                          loading = false;
                        }),
                      },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
