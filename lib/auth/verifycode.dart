import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/ui/home_screen.dart';
import 'package:loginpage/utils/utils.dart';
import 'package:loginpage/widget/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verifivationId;
  const VerifyCodeScreen({super.key, required this.verifivationId});
  @override
  State<VerifyCodeScreen> createState() => VerifyCodeScreenState();
}

class VerifyCodeScreenState extends State<VerifyCodeScreen> {
  var verifyController = TextEditingController();
  bool loading = false;
  var _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify Phone Number")),
      body: Padding(
        padding: EdgeInsets.all(21),
        child: Column(
          children: [
            TextField(
              controller: verifyController,
              decoration: InputDecoration(hintText: "6 digit code"),
            ),
            SizedBox(height: 20),
            RoundButton(
              title: "Verify",
              onTap: () async {
                setState(() {
                  loading = true;
                });
                final crendital = PhoneAuthProvider.credential(
                  verificationId: widget.verifivationId,
                  smsCode: verifyController.text.toString(),
                );
                try {
                  await _auth.signInWithCredential(crendital);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => HomeScreen(
                            name: "great u reached by phonenum here",
                          ),
                    ),
                  );
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  Utils().showToastMsg(e.toString());
                }
              },
              loading: loading,
            ),
          ],
        ),
      ),
    );
  }
}
