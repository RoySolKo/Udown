import 'package:flutter/material.dart';
import 'package:udown/services/google_calendar.dart';

class Checklist extends StatefulWidget {
  final Map map;
  Checklist({Key key, @required this.map}) : super(key: key);

  @override
  _ChecklistState createState() => _ChecklistState(map);
}

class _ChecklistState extends State<Checklist> {
  Map map;
  _ChecklistState(this.map);
  List<Widget> checkboxes = List();
  Map<String, bool> checks = Map();
  List<String> calendarList = List();

  @override
  void initState() {
    super.initState();
    if (checkboxes.isEmpty) {
      map.keys.forEach((element) {
        calendarList.add(element);
      });
      for (String stuff in calendarList) {
        checkboxes.add(MyCheckBox(stuff, setBool));
      }
    }
  }

  void setBool(String key, bool val) {
    checks[key] = val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
        body: SimpleDialog(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          title: Text("Google Calendars"),
          children: <Widget>[
            Column(children: checkboxes),
            Row(children: [
              Expanded(
                  child: FlatButton(
                      child: Text("Back"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })),
              Expanded(
                  child: FlatButton(
                      child: Text("Confirm"),
                      onPressed: () {
                        checks.forEach((key, value) {
                          if (value) {
                            GoogleCalActions().getEvents(map[key]);
                            Navigator.of(context).pop();              
                          }
                        });
                      }))
            ])
          ],
        ));
  }
}

class MyCheckBox extends StatefulWidget {
  final String text;
  final setParent;
  MyCheckBox(this.text, this.setParent);

  @override
  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.text),
      value: _value,
      onChanged: (bool value) {
        setState(() {
          _value = value;
        });
        widget.setParent(widget.text, _value);
      },
    );
  }
}
