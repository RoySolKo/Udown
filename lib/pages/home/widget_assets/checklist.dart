import 'package:flutter/material.dart';

class Checklist extends StatefulWidget {
  final List<String> list;
  Checklist({Key key, @required this.list}) : super(key: key);

  @override
  _ChecklistState createState() => _ChecklistState(list);
}

class _ChecklistState extends State<Checklist> {
  List<String> list;
  _ChecklistState(this.list);
  List<Widget> checkboxes = List();
  Map<String, bool> checks = Map();

  @override
  void initState() {
    super.initState();
    if (checkboxes.isEmpty) {
      for (String element in list) {
        checkboxes.add(MyCheckBox(element, setBool));
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
                        print("XXXXX");
                        print(checks);
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
