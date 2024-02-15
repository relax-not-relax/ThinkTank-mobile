import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/models/account.dart';

class ApiAuthentication {
  static Future<Account?> postDataWithJson(
      String username, String password) async {
    Map<String, String> loginData = {
      "userName": username,
      "password": password,
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
}
