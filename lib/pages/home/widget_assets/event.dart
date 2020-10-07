import 'package:flutter/material.dart';

class EventList {
  List<Event> allevents;

  List<Event> findallbetween(DateTime start, DateTime end) {}

  List<Event> findoverlap() {}
}

class Event {
  DateTime time;
  String eventname;
}

class EventCard extends StatefulWidget {
  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
