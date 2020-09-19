import 'package:flutter/material.dart';
import 'package:udown/pages/authenticate/registration_page/register.dart';
import 'package:udown/pages/home/overview.dart';
import 'package:udown/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  final AuthService _auth = AuthService();

  String email;
  String password;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 3000));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

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
                  autovalidate: true,
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
                      new FlatButton(
                          onPressed: () {},
                          color: Colors.white,
                          textColor: Colors.blue,
                          child: Text("forgot password?")),
                      new Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                      ),
                      new MaterialButton(
                        height: 50.0,
                        minWidth: 150.0,
                        color: Colors.green,
                        splashColor: Colors.teal,
                        textColor: Colors.white,
                        child: Text("Login"),
                        onPressed: () async {
                          dynamic user = await _auth.signInWithEmailAndPassword(
                              email, password);
                          if (user == null) {
                            print('Wrong Username or Password');
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Overview()),
                            );
                          }
                        },
                      ),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an Account?",
                              style: TextStyle(color: Colors.blue[400]),
                            ),
                            new FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()),
                                  );
                                },
                                child: Text("Sign up"))
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
