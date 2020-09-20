import 'package:flutter/material.dart';
import 'package:udown/pages/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("SomethingWentWrong");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return OverlaySupport(
              child: MaterialApp(
            theme: new ThemeData(primarySwatch: Colors.blue),
            home: new Wrapper(),
          ));
        }

        // Otherwise, show something whilst waiting for initialization to complete
        print("loading"); //change this and container() to loading screen later
        return Container();
      },
    );
  }
}
