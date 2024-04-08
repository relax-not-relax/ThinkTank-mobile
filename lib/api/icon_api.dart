import 'dart:convert';

import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/icon.dart';
import 'package:http/http.dart' as http;

class ApiIcon {
  static Future<void> getIconsOfAccount() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/iconOfAccounts?AccountId=${account!.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    List<IconApp> results = [];

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      for (var element in jsonData['results']) {
        results.add(IconApp.fromJson(element));
      }

      await SharedPreferencesHelper.saveIconSources(results);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/iconOfAccounts?AccountId=${account2!.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        print(jsonData);
        for (var element in jsonData) {
          results.add(IconApp.fromJson(element));
        }
        await SharedPreferencesHelper.saveIconSources(results);
      } else {
        print("Error");
      }
    } else {
      print("Error");
    }
  }
}
