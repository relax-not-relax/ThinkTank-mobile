import 'dart:convert';
import 'package:http/http.dart' as http;
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
          'https://thinktank-sep490.azurewebsites.net/api/accounts/authentication'),
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
}
