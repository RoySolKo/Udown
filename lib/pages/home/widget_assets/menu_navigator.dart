import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udown/pages/authenticate/login.dart';
import 'package:udown/pages/home/widget_assets/DeveloperNotes.dart';
import 'package:udown/pages/home/widget_assets/checklist.dart';
import 'package:udown/pages/loading_page.dart';
import 'package:udown/services/auth.dart';
import 'package:udown/services/google_calendar.dart';
import 'package:udown/services/secret.dart';

class DropMenu extends StatefulWidget {
  @override
  _DropMenuState createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> {
  AuthService auth = AuthService();

  void choiceAction(String choice) async {
    if (choice == Constants.settings) {
    } else if (choice == Constants.signOut) {
      auth.signOut();
      auth.signOutGoogle();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else if (choice == Constants.importGoogleCalendar) {
      Map calendarMap = await GoogleCalActions().getCalendars();
      if (calendarMap != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Checklist(
                      map: calendarMap,
                    )));
      }
    } else if (choice == Constants.importOutlookCalendar) {
    } else if (choice == Constants.developerTestButton) {
       Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loading()));
    } else if (choice == Constants.developerNotes) {Navigator.push(
          context, MaterialPageRoute(builder: (context) => DeveloperNotes()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: choiceAction,
      itemBuilder: (BuildContext context) {
        return Constants.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}

class Constants {
  static const String settings = 'Settings(Dark Mode Coming Soon)';
  static const String signOut = 'Sign out';
  static const String importGoogleCalendar = 'Import Google Calendar';
  static const String importOutlookCalendar =
      'Import Outlook Calendar (coming soon)';
  static const String developerTestButton = 'Developer Test Button';
  static const String developerNotes = 'Developer Notes';

  static const List<String> choices = <String>[
    developerTestButton,
    importGoogleCalendar,
    importOutlookCalendar,
    settings,
    developerNotes,
    signOut
  ];
}
