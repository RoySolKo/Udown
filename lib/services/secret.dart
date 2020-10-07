import "dart:convert";
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';

class Secret {
  // Create storage
  final storage = FlutterSecureStorage();

  // Read value
  Future<String> read(key) async {
    String value = await storage.read(key: key);
    return value;
  }

  // Read all values
  Future<Map<String, String>> readAll() async {
    Map<String, String> allValues = await storage.readAll();
    return allValues;
  }

  // Delete value
  Future<void> delete(key) async {
    await storage.delete(key: key);
  }

  /* Delete all
  Future<void> deleteAll() async {
    await storage.deleteAll();
  }
  */

  // Write value
  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  //Save Credentials
  Future saveCredentials(AccessToken token, String refreshToken) async {
    print(token.expiry.toIso8601String());
    await storage.write(key: "type", value: token.type);
    await storage.write(key: "data", value: token.data);
    await storage.write(key: "expiry", value: token.expiry.toString());
    await storage.write(key: "refreshToken", value: refreshToken);
  }

  //Get Saved Credentials
  Future<Map<String, dynamic>> getCredentials() async {
    Map<String, dynamic> response = {
      "type": await storage.read(key: "type"),
      "data": await storage.read(key: "data"),
      "expiry": await storage.read(key: "expiry"),
      "refreshToken": await storage.read(key: "refreshToken")
    };
    if (response["type"] == null ||
        response["data"] == null ||
        response["expiry"] == null ||
        response["refreshToken"] == null) return null;
    if (response.length == 0) return null;
    return response;
  }

  Future<void> deleteCredentials() async {
    storage.delete(key: "type");
    storage.delete(key: "data");
    storage.delete(key: "expiry");
    storage.delete(key: "refreshToken");
  }

  void printCredentials() async {
    Future<Map<String, String>> keys = storage.readAll().then((value) {
      var mapInJsonString = json.encode(value);
      JsonEncoder encoder = new JsonEncoder.withIndent(' ');
      String prettyprint = encoder.convert(mapInJsonString);
      debugPrint(prettyprint);
    });
  }
}
