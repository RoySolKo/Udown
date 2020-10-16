import 'package:flutter/material.dart';

class CalEvents {
  List<CalEvent> allevents = List();

  void addCalEvent(CalEvent event) {
    allevents.add(event);
  }

  Map<String, Object> toGoogJson() {
    final Map<String, Object> _json = Map<String, Object>();
    allevents.forEach((element) {
      _json[element.googleid]=element.toJson();
    });
    return _json;
  }

  List<CalEvent> findallbetween(DateTime start, DateTime end) {}

  List<CalEvent> findoverlap() {}
}
/* 
Properties you can get from google for each event

attendees, created, creator, end, etag, extendedProperties, htmlLink, iCalUID, id, kind, 
organizer, reminders, sequence, start, status, summary, updated, description, location, transparency, visibility
*/
class CalEvent {
  String googleid; //id:
  String eventname; //summary: TEST EVENT
  DateTime startime; //start: {dateTime: 2020-11-07T11:00:00.000Z}
  DateTime endtime; //end: {date: 2020-10-1

  CalEvent(this.googleid, this.eventname, {this.startime, this.endtime});

  Map<String, Object> toJson() {
    final Map<String, Object> _json =
        new Map<String, Object>();
    /*
    if (googleid != null) {
      _json["googleid"] = this.googleid;
    }*/
    if (eventname != null) {
      _json["eventname"] = this.eventname;
    }
    if (startime != null) {
      _json["startime"] = this.startime;
    }
    if (endtime != null) {
      _json["endtime"] = this.endtime;
    }

    return _json;
  }
}

class EventCard extends StatefulWidget {
  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
