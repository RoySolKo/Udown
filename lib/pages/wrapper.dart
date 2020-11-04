import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:udown/pages/authenticate/login.dart";
import "package:udown/pages/home/overview.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udown/pages/loading_page.dart';
import 'package:udown/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:udown/services/database.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<AuthService>(context).auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return LoginPage();
          }
          return StreamProvider(
              create:(_)=>DatabaseServices().streamUserEvents(),
              child: Overview());
        } else {
          return Scaffold(body: Center(child: Text('Loading...')));
        }
      },
    );
  }
}
