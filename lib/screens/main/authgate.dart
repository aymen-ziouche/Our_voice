import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:our_voice/screens/auth/signin_screen.dart';
import 'package:our_voice/screens/main/mainpage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);
  static String id = "AuthGate";


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    // User is not signed in
    if (!snapshot.hasData) {
      return SigninPage();
    }

    // Render your application if authenticated
    return MainPage();
  },
);
  }
}