import "package:flutter/material.dart";
import 'package:udown/main.dart';
import "package:udown/pages/authenticate/login.dart";
import "package:udown/pages/home/overview.dart";
//import 'package:udown/models/AppUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    print('printing auth');
    print(auth);
    auth.authStateChanges().listen((User user) {
     
      print(user);
      if (user == null) {
         print('user is null');
        return new LoginPage();
      } else {
        return new Overview();
      }
    });
    return LoginPage();
  }
}