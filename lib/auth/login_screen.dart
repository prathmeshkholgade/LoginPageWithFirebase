import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loginpage/auth/loginwithphonenum.dart';
import 'package:loginpage/auth/signup_screen.dart';
import 'package:loginpage/ui/home_screen.dart';
import 'package:loginpage/utils/utils.dart';
import 'package:loginpage/widget/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  void loginUser() async {
    try {
      await _auth
          .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => HomeScreen(name: value.user!.email.toString()),
              ),
            );
          });
    } catch (error) {
      Utils().showToastMsg(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
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
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: RoundButton(
                    title: "Login",
                    loading: loading,
                    onTap: loginUser,
                  ),
                ),
              ],
            ),
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
                                builder: (context) => SignupScreen(),
                              ),
                            ),
                          },
                      child: RichText(
                        text: TextSpan(
                          text: "don't have an account",
                          children: const <TextSpan>[
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: TextButton(
                onPressed: () async {
                  // GoogleSignIn googleSignIn = GoogleSignIn(
                  //   clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
                  // );

                  final GoogleSignIn google_sign_in = GoogleSignIn(
                    clientId:
                        "842873462908-uckia047ae104lap85l5s9vlnuf5h5nt.apps.googleusercontent.com",
                  );
                  try {
                    final GoogleSignInAccount? google_account =
                        await google_sign_in.signIn();
                    if (google_account != null) {
                      final GoogleSignInAuthentication g_sign_auth =
                          await google_account.authentication;
                      final AuthCredential credential =
                          GoogleAuthProvider.credential(
                            idToken: g_sign_auth.idToken,
                            accessToken: g_sign_auth.accessToken,
                          );
                      await _auth.signInWithCredential(credential);
                    }
                  } catch (e) {
                    Utils().showToastMsg(e.toString());
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.google, color: Colors.white),
                    SizedBox(width: 5),
                    Text("Login With google"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginWithPhoneNum(),
                      ),
                    ),
                  },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),

                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginWithPhoneNum(),
                        ),
                      );
                    },
                    child: Text("Login with phone number"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
