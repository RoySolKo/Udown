import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:udown/pages/home/widget_assets/event.dart';
import 'package:udown/services/auth.dart';

class DatabaseServices {
  final String uid = AuthService().getUserID();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  
  void updateUserEvents(List<Event> eventlist) async {
    CalEvents newdata = CalEvents();
    eventlist.forEach((element) {
      EventDateTime start = element.start;
      EventDateTime end = element.end;
      CalEvent event;

      if (end == null) {
      } else {
        event = CalEvent(element.iCalUID, element.summary,
            end: element.end.dateTime ?? element.end.date, start: start.dateTime ?? start.date);
        newdata.addCalEvent(event);
        users
            .doc(uid)
            .collection('events')
            .doc(element.iCalUID)
            .set(event.toJson());
      }
    });
  }

  Stream<QuerySnapshot> streamUserEvents() {
    final CollectionReference events = FirebaseFirestore.instance.collection('users').doc(uid).collection('events');

    return events.snapshots();
  }
}
