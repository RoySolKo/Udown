import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeveloperNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: ListView(
      scrollDirection: Axis.vertical,
      children: [
        Text('Plans for future versions:'),
        Text('-Day View'),
        Text('-Dark mode'),
        Text('-Add Events'),
        Text('-Delete Events'),
        Text('-Import Outlook Calender'),
        Text('-Suggest/Accept Meetings'),
        Text('')],
    ))));
  }
}
