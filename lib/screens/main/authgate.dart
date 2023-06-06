import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:our_voice/providers/artProvider.dart';
import 'package:our_voice/providers/userprovider.dart';
import 'package:our_voice/screens/auth/signin_screen.dart';
import 'package:our_voice/screens/main/mainpage.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);
  static String id = "AuthGate";

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    // final userProvider = context.read<UserProvider>();
    // userProvider.fetchUser();
    // final artProvider = context.read<ArtProvider>();
    // artProvider.fetchArts();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return const SigninPage();
        }

        // Render your application if authenticated
        return const MainPage();
      },
    );
  }
}
