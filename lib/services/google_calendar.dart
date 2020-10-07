import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import "package:http/http.dart" as http;
import 'package:overlay_support/overlay_support.dart';
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
      });
      closeWebView();
      //Save Credentials
      Secret().saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken);
      return authClient;
    } else {
      print(credentials["expiry"]);
      //Already authenticated
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])),
              credentials["refreshToken"],
              _scopes));
    }
  }

  Future<List<String>> getCalendars() async {
    var client = await getAuth();
    var connection = CalendarApi(client);
    List<String> calendarlist = List();
    try {
      CalendarList response =
          await connection.calendarList.list(showHidden: true);
      response.items.forEach((element) {
        calendarlist.add(element.summary);
      });
      return calendarlist;
    } catch (e) {
      print(e);
      toast("credentials expired");
      Secret().printCredentials();
      Secret().deleteCredentials();
      return getCalendars();
    }
    /*
    connection.calendarList
        .list(showHidden: true)
        .then((CalendarList response) {
      response.items.forEach((element) {
        calendarlist.add(element.summary);
      });
    }).then((_) {
      print("api " + calendarlist.toString());
      return calendarlist;
    }).catchError((e) {
      print(e);
      Secret().deleteCredentials();
      return importCalendar();
    });
    return null;*/
  }
}
