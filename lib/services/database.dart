import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:udown/pages/home/widget_assets/event.dart';
import 'package:udown/services/auth.dart';

class DatabaseServices {
  final String uid = AuthService().getUserID();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference events =
      FirebaseFirestore.instance.collection('events');

  void updateUserEvents(List<Event> eventlist) async {
    CalEvents newdata = CalEvents();
    eventlist.forEach((element) {
      EventDateTime start = element.start;
      EventDateTime end = element.end;
      CalEvent event;
      if (start == null && end == null) {
        event = CalEvent(element.id, element.summary);
      } else {
        event = CalEvent(element.id, element.summary,
            startime: start.dateTime, endtime: end.dateTime);
      }
      newdata.addCalEvent(event);
    });
    users.doc(uid).set({'GoogEvents': newdata.toGoogJson()});
  }

  Stream<DocumentSnapshot> streamUserEvents() {
    return users.doc(uid).snapshots();
  }
}
