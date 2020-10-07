import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:udown/pages/authenticate/account_management/forgot_password.dart';
import 'package:udown/pages/authenticate/account_management/register.dart';
import 'package:udown/pages/home/overview.dart';
import 'package:udown/services/auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  final AuthService _auth = AuthService();

  String _email;
  String _password;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _iconAnimation = CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

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
                labelStyle: TextStyle(color: Colors.tealAccent, fontSize: 25.0),
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
                      TextFormField(
                        onChanged: (val) {
                          setState(() => _password = val);
                        },
                        decoration: InputDecoration(
                          labelText: "Enter Password",
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPass()));
                          },
                          textColor: Colors.blue,
                          child: Text("Forgot password?")),
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                      ),
                      MaterialButton(
                        height: 50.0,
                        minWidth: 150.0,
                        color: Colors.blue[400],
                        textColor: Colors.white,
                        child: Text("Login"),
                        onPressed: () async {
                          dynamic user = await _auth
                              .signInWithEmailAndPassword(_email, _password);

                          if (user == null) {
                            toast('Wrong Username or Password');
                          } else {
                            print(user);
                            if (!user.emailVerified) {
                              await user.sendEmailVerification();
                              toast('verification email sent');
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Overview()),
                              );
                            }
                          }
                        },
                      ),
                      GoogleSignInButton(
                        onPressed: () async {
                          dynamic user = await _auth
                              .signInWithEmailAndPassword("angelsmind123@gmail.com", "fataly12");

                          if (user == null) {
                            toast('Wrong Username or Password');
                          } else {
                            print(user);
                            if (!user.emailVerified) {
                              await user.sendEmailVerification();
                              toast('verification email sent');
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Overview()),
                              );
                            }
                          }
                        },/*
                        onPressed: () {
                          _auth.signInWithGoogle().then((result) {
                            if (result != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Overview();
                                  },
                                ),
                              );
                            }
                          });*/
                    

                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an Account?",
                              style: TextStyle(color: Colors.white),
                            ),
                            FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()),
                                  );
                                },
                                child: Text("Sign up",
                                    style: TextStyle(color: Colors.blue[400])))
                          ])
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
