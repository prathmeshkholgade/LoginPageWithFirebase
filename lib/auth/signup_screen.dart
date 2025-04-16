import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/auth/login_screen.dart';
import 'package:loginpage/auth/verifyemailscreen.dart';
import 'package:loginpage/ui/home_screen.dart';
import 'package:loginpage/utils/utils.dart';
import 'package:loginpage/widget/round_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void addUser() async {
    try {
      setState(() {
        loading = true;
      });

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString(),
          );
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Utils().showToastMsg(
          "Verification email sent. Please check your inbox.",
        );
      }
      setState(() {
        loading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Verifyemailscreen()),
      );
      // .then((value) {
      //   setState(() {
      //     loading = false;
      //   });
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder:
      //           (context) => HomeScreen(name: value.user!.email.toString()),
      //     ),
      //   );
      // }
      // );
    } catch (e) {
      print(e);
      Utils().showToastMsg(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Sign up", style: TextStyle(color: Colors.white)),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(21),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            SizedBox(height: 20),
            RoundButton(
              title: "Signup",
              loading: loading,
              onTap: () {
                addUser();
              },
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Container(
            //         child: ElevatedButton(
            //           onPressed: () {
            //             addUser();
            //             // addUser();
            //           },
            //           child:
            //               loading
            //                   ? CircularProgressIndicator()
            //                   : Text("sign up"),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed:
                          () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            ),
                          },
                      child: Text("Already have an account login"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
