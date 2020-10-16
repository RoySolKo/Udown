import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import "package:http/http.dart" as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:udown/pages/home/widget_assets/event.dart';
import 'package:udown/services/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:udown/services/secret.dart';

const _scopes = const [CalendarApi.CalendarScope];

class GoogleCalActions {
  //https://developers.google.com/identity/protocols/oauth2/images/flows/authorization-code.png
  //request token with user login and consent
  Future<http.Client> getAuth() async {
    //Get Credentials
    String _clientId = await Secret().read("google-client-id");
    var credentials = await Secret().getCredentials();
    if (credentials == null) {
      //Needs user authentication
      var authClient =
          await clientViaUserConsent(ClientId(_clientId, ""), _scopes, (url) {
        //Open Url in Browser
        launch(url);
        closeWebView();
      });
      //Save Credentials
      Secret().saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken);
      return authClient;
    } else {
      print(credentials["expiry"]);
      //Already authenticated
      return autoRefreshingClient(
          ClientId(_clientId, ""),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])),
              credentials["refreshToken"],
              _scopes),http.Client());
    }
  }

  Future<Map> getCalendars() async {
    var client = await getAuth();
    var connection = CalendarApi(client);
    Map<String, String> calendarlist = Map();
    try {
      CalendarList response =
          await connection.calendarList.list(showHidden: true);
      response.items.forEach((element) {
        calendarlist[element.summary] = element.id;
      });
      return calendarlist;
    } catch (e) {
      print(e);
      toast("credentials expired");
      Secret().printCredentials();
      Secret().deleteCredentials();
      return getCalendars();
    }
  }

  void getEvents(String calendarId) async {
    var client = await getAuth();
    var connection = CalendarApi(client);
    try {
      var response = await connection.events.list(calendarId);
      DatabaseServices().updateUserEvents(response.items);
      /*
      response.items.forEach((Event event) {
        DatabaseServices().updateUserEvents(
        CalEvent(event.id,event.summary,event.start.dateTime,event.end.dateTime)

        );
      });
      */
    } catch (e) {
      print('Error retrieving events: $e');
      toast("credentials expired");
      Secret().printCredentials();
      Secret().deleteCredentials();
      getEvents(calendarId);
    }
  }

  Future<void> insertEvent(Event event) async {
    var client = await getAuth();
    var connection = CalendarApi(client);
    try {
      String calendarId = "primary";
      connection.events.insert(event, calendarId).then((value) {
        print("ADDEDDD_________________${value.status}");
        if (value.status == "confirmed") {
          print('Event added in google calendar');
        } else {
          print("Unable to add event in google calendar");
        }
      });
    } catch (e) {
      print('Error creating event $e');
    }
  }

  Future<void> deleteEvent(String calendarId, String eventId) async {
    var client = await getAuth();
    var connection = CalendarApi(client);
    try {
      String calendarId = "primary";
      connection.events.delete(calendarId, eventId).then((value) {
        print("deleted_________________${value.status}");
        if (value.status == "confirmed") {
          print('Event deleted in google calendar');
        } else {
          print("Unable to delete event in google calendar");
        }
      });
    } catch (e) {
      print('Error deleting event $e');
    }
  }
}
