import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:udown/pages/home/widget_assets/event.dart';
import 'package:udown/pages/home/widget_assets/menu_navigator.dart';
import 'package:lunar_calendar_converter/lunar_solar_converter.dart';
import 'package:udown/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DayView extends StatefulWidget {
  @override
  DateTime today;
  DayView({Key key, @required this.today});

  _DayViewState createState() => _DayViewState(today);
}

class _DayViewState extends State<DayView> {
  DateTime today;
  _DayViewState(this.today);
  List<Widget> _eventListBuilder = List();

  void getLunarToday({DateTime day}) {
    if (day == null) {
      Solar solar = Solar(
          solarYear: this.today.year,
          solarMonth: this.today.month,
          solarDay: this.today.day);
      print(LunarSolarConverter.solarToLunar(solar));
    } else {
      Solar solar =
          Solar(solarYear: day.year, solarMonth: day.month, solarDay: day.day);
      print(LunarSolarConverter.solarToLunar(solar));
    }
  }

  void _initializeEvents() {
    print(context.watch<QuerySnapshot>());/*
    Provider.of<QuerySnapshot>(context,listen: true).docs.forEach((doc) {
      Map data = doc.data();
      _eventListBuilder.add(_buildEventCards(
          data['summary'],
          DateTime.parse(data['start']['date']) ?? data['start']['dateTime'],
          DateTime.parse(data['end']['date'] ?? data['end']['dateTime'])));
    });*/
  }

  @override
  Widget build(BuildContext context) {
    //_initializeEvents();
    String formatedDate = DateFormat('MM-dd-yyyy').format(today);
    return Scaffold(
        floatingActionButton:
            FloatingActionButton(onPressed: null, child: Icon(Icons.add)),
        appBar: AppBar(title: Text(formatedDate), actions: <Widget>[
          DropMenu(),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 6, 0))
        ]),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: _eventListBuilder,
        ));
  }

  Widget _buildEventCards(String summary, DateTime start, DateTime end) {
    return Container(
      child: Text(summary),
      height: 30,
      color: Colors.white,
    );
  }
}
