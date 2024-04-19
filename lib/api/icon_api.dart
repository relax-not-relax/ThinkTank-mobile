import 'dart:convert';

import 'package:thinktank_mobile/api/account_api.dart';
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/icon.dart';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/models/icon_of_server.dart';

class ApiIcon {
  static Future<void> getIconsOfAccount() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/iconOfAccounts?PageSize=60&AccountId=${account!.id}'),
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
      print(results.length);
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

  static Future<dynamic> getAllIcons() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/icons?PageSize=50&StatusIcon=3&AccountId=${account!.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    List<IconServer> results = [];

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      for (var element in jsonData['results']) {
        results.add(IconServer.fromJson(element));
      }
      return results;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/icons?PageSize=50&StatusIcon=3&AccountId=${account2!.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        print(jsonData);
        for (var element in jsonData['results']) {
          results.add(IconServer.fromJson(element));
        }
        return results;
      } else {
        final error = json.decode(response2.body)['error'];
        return error;
      }
    } else {
      final error = json.decode(response.body)['error'];
      return error;
    }
  }

  static Future<dynamic> buyIcon(int iconId) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    Map<String, dynamic> request = {"accountId": account!.id, "iconId": iconId};

    String jsonBody = jsonEncode(request);

    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/iconOfAccounts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      IconApp icon = IconApp.fromJson(jsonData);
      await ApiAccount.updateCoin();
      return icon;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      Map<String, dynamic> request = {
        "accountId": account2.id,
        "iconId": iconId
      };
      String jsonBody = jsonEncode(request);

      final response2 = await http.post(
        Uri.parse(
            'hhttps://thinktank-sep490.azurewebsites.net/api/iconOfAccounts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
        body: jsonBody,
      );

      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        print(jsonData);
        IconApp icon = IconApp.fromJson(jsonData);
        await ApiAccount.updateCoin();
        return icon;
      } else {
        final error = json.decode(response2.body)['error'];
        return error;
      }
    } else {
      final error = json.decode(response.body)['error'];
      return error;
    }
  }
}
