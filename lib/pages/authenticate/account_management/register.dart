import 'package:flutter/material.dart';
import 'package:udown/pages/authenticate/login.dart';
import 'package:udown/services/auth.dart';
import 'package:overlay_support/overlay_support.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email;
  String password;
  String password2;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        new Image(
          image: new AssetImage("assets/Logo.jpg"),
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.darken,
          color: Colors.black87,
        ),
        new Theme(
          data: new ThemeData(
              brightness: Brightness.dark,
              inputDecorationTheme: new InputDecorationTheme(
                // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                labelStyle:
                    new TextStyle(color: Colors.tealAccent, fontSize: 25.0),
              )),
          isMaterialAppTheme: true,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlutterLogo(
                size: 99,
              ),
              new Container(
                padding: const EdgeInsets.all(40.0),
                child: new Form(
                  autovalidateMode:AutovalidateMode.always,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new TextFormField(
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        decoration: new InputDecoration(
                            labelText: "Enter Email", fillColor: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      new TextFormField(
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        decoration: new InputDecoration(
                          labelText: "Enter Password",
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      new TextFormField(
                        onChanged: (val) {
                          setState(() => password2 = val);
                        },
                        decoration: new InputDecoration(
                          labelText: "Renter Password",
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                      ),
                      RaisedButton(
                          child: Text("Register"),
                          onPressed: () async {
                            if (password != password2) {
                              toast('Passwords do not match',
                                  duration: Toast.LENGTH_LONG);
                            } else {
                              dynamic response =
                                  await _auth.createUserWithEmailAndPassword(
                                      email, password);
                              if (response == null) {
                                //handled in auth.dart
                              } else {
                                toast('Registration Success',
                                    duration: Toast.LENGTH_LONG);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              }
                            }
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
