import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:udown/pages/home/widget_assets/event.dart';
import 'package:udown/services/auth.dart';

class DatabaseServices {
  final String uid = AuthService().getUserID();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  CollectionReference localInstanceEvents;

  void updateUserEvents(List<Event> eventlist) async {
    eventlist.forEach((element) {
      EventDateTime start = element.start;
      if (start != null) {
        users
            .doc(uid)
            .collection('eventList')
            .doc(element.iCalUID)
            .set(element.toJson());
      }
    });
  }

  Future<QuerySnapshot> getUserEvents({DateTime day}) async {
    if (day != null) {
      final QuerySnapshot dayevents = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('events')
          .where('startime',
              isGreaterThanOrEqualTo: day,
              isLessThanOrEqualTo: day.add(Duration(days: 1)))
          .orderBy('startime')
          .get();

      return dayevents;
    }

    final QuerySnapshot events = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('events')
        .get();

    return events;
  }

  Stream<QuerySnapshot> streamUserEvents({DateTime day}) {
    if (day != null) {
      final Query dayevents = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('eventList')
          .where('start',
              isGreaterThanOrEqualTo: day,
              isLessThanOrEqualTo: day.add(Duration(days: 1)))
          .orderBy('start');

      return dayevents.snapshots().asBroadcastStream();
    }

    final CollectionReference events = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('eventList')
        .orderBy('start');

      events.snapshots().listen((event) {
        localInstanceEvents = events;
      });

    return events.snapshots();
  }
}
