import "package:flutter/material.dart";
import "package:udown/pages/authenticate/login.dart";
import "package:udown/pages/home/overview.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udown/services/auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthService().auth.authStateChanges(),
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
