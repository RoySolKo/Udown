import 'package:flutter/material.dart';
import 'package:udown/pages/authenticate/login.dart';
import 'package:udown/services/auth.dart';
import 'package:overlay_support/overlay_support.dart';

class ForgotPass extends StatefulWidget {
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {

  String _email;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(fit: StackFit.expand, children: <Widget>[
       Image(
          image: AssetImage("assets/Logo.jpg"),
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.darken,
          color: Colors.black87,
        ),
       Theme(
          data: ThemeData(
              brightness: Brightness.dark,
              inputDecorationTheme: InputDecorationTheme(
                // hintStyle: TextStyle(color: Colors.blue, fontSize: 20.0),
                labelStyle:
                   TextStyle(color: Colors.tealAccent, fontSize: 25.0),
              )),
          isMaterialAppTheme: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Image(
                height: 99,
                width: 99,
                image: AssetImage("assets/Logo.jpg"),
              ),
             Container(
                padding: const EdgeInsets.all(40.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        onChanged: (val) {
                          setState(() => _email = val);
                        },
                        decoration: InputDecoration(
                            labelText: "Enter Email", fillColor: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Padding(padding: const EdgeInsets.only(top: 60.0)),
                      MaterialButton(
                        height: 50.0,
                        minWidth: 150.0,
                        color: Colors.blue[400],
                        textColor: Colors.white,
                        child: Text("Send Verification Email"),
                        onPressed: () {
                          _auth.resetPassword(_email);
                          toast('Verification Email Sent');
                          Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                          }
                      ),
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