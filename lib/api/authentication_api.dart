import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/models/account.dart';

class ApiAuthentication {
  static Future<Account?> login(
      String username, String password, String fcmToken) async {
    Map<String, String> loginData = {
      "userName": username,
      "password": password,
      "fcm": fcmToken
    };
    String jsonBody = jsonEncode(loginData);

    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/authentication-player'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      FirebaseRealTime.setOnline(Account.fromJson(jsonData).id, true);
      return Account.fromJson(jsonData);
    } else {
      return null;
    }
  }

  static Future<http.Response> register(
      String fullname, String username, String email, String password) async {
    Map<String, String?> data = {
      "fullName": fullname,
      "userName": username,
      "email": email,
      "password": password,
      "fcm": null,
      "googleId": null
    };
    String jsonBody = jsonEncode(data);
    final response = await http.post(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/accounts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );
    return response;
  }

  static Future<Account?> refreshToken(
    String? refreshToken,
    String? accessToken,
  ) async {
    Map<String, String?> data = {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
    String jsonBody = jsonEncode(data);
    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/token-verification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Account.fromJson(jsonData);
    } else {
      return null;
    }
  }
}
