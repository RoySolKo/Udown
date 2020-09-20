import "package:flutter/material.dart";
import "package:udown/pages/authenticate/login.dart";
import "package:udown/pages/home/overview.dart";
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return LoginPage();
          }
          return Overview();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
