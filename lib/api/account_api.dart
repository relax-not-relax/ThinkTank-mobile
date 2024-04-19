//import 'dart:convert';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:synchronized/synchronized.dart';
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/api/lock_manager.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';

class ApiAccount {
  static Future<String> addFile(String filePath, String authToken) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('https://thinktank-sep490.azurewebsites.net/api/files'));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $authToken',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      //final responseData = json.decode(response.body);
      return response.body;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      http.MultipartRequest request = http.MultipartRequest('POST',
          Uri.parse('https://thinktank-sep490.azurewebsites.net/api/files'));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ${account2!.accessToken}',
      });

      var streamedResponse2 = await request.send();
      var response2 = await http.Response.fromStream(streamedResponse2);

      if (response2.statusCode == 200) {
        return response2.body;
      } else {
        return "Can't upload file";
      }
    } else {
      return "Can't upload file";
    }
  }

  static Future<dynamic> updateProfile(
    String fullName,
    String email,
    String gender,
    String dateOfBirth,
    String avatar,
    String oldPassword,
    String newPassword,
    String authToken,
    int id,
  ) async {
    Map<String, String?> data = {
      "fullName": fullName,
      "email": email,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "avatar": avatar,
      "oldPassword": oldPassword,
      "newPassword": newPassword
    };

    String jsonBody = jsonEncode(data);

    final response = await http.put(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/accounts/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(response.body);
      Account account = Account.fromJson(jsonData);
      await SharedPreferencesHelper.saveInfo(account);
      return account;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.put(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accounts/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
        body: jsonBody,
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        Account account = Account.fromJson(jsonData);
        await SharedPreferencesHelper.saveInfo(account);
        return account;
      } else {
        final error = json.decode(response2.body)['error'];
        return error;
      }
    } else {
      final error = json.decode(response.body)['error'];
      return error;
    }
  }

  static Future<dynamic> getAccountById() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/${account!.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      Account _acc = Account.fromJson(jsonData);
      SharedPreferencesHelper.saveInfo(_acc);
      return _acc;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accounts/${account2!.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        print(jsonData);
        Account _acc = Account.fromJson(jsonData);
        SharedPreferencesHelper.saveInfo(_acc);
        return _acc;
      } else {
        final error = json.decode(response2.body)['error'];
        return error;
      }
    } else {
      final error = json.decode(response.body)['error'];
      return error;
    }
  }

  static Future<void> updateCoin() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/${account!.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      Account _acc = Account.fromJson(jsonData);
      account.coin = _acc.coin;
      SharedPreferencesHelper.saveInfo(account);
      return;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await ApiAuthentication.refreshToken();
      return;
    } else {
      return;
    }
  }
}
