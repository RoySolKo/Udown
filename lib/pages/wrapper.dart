import "package:flutter/material.dart";
import "package:udown/pages/authenticate/login.dart";
import "package:udown/pages/home/overview.dart";

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return login or overview based on login status
    if (loggedin) {
      return Overview();
    } else {
      return LoginPage();
    }
  }
}
