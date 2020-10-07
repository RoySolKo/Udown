import 'package:flutter/material.dart';
import 'package:udown/pages/home/widget_assets/event.dart';
import 'package:udown/pages/home/widget_assets/menu_navigator.dart';
import 'package:lunar_calendar_converter/lunar_solar_converter.dart';

class DayView extends StatefulWidget {
  @override
  _DayViewState createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  void getLunarToday(DateTime day) {
    DateTime.now();
    Solar solar =
        Solar(solarYear: day.year, solarMonth: day.month, solarDay: day.day);
    print(LunarSolarConverter.solarToLunar(solar));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Calender'), actions: <Widget>[
        DropMenu(),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 6, 0))
      ]),
      body: Column(),
    );
  }
}
