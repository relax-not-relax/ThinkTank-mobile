//import 'dart:convert';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/authentication_api.dart';
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
      Account? account = await SharedPreferencesHelper.getInfo();
      Account? account2 = await ApiAuthentication.refreshToken(
          account!.refreshToken, account.accessToken);
      SharedPreferencesHelper.saveInfo(account2!);
      http.MultipartRequest request = http.MultipartRequest('POST',
          Uri.parse('https://thinktank-sep490.azurewebsites.net/api/files'));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $authToken',
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

  static Future<Account?> updateProfile(
    String fullName,
    String userName,
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
      "userName": userName,
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
      Account? account2 = await SharedPreferencesHelper.getInfo();
      account.accessToken = account2!.accessToken;
      account.refreshToken = account2.refreshToken;
      return account;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account = await SharedPreferencesHelper.getInfo();
      Account? account2 = await ApiAuthentication.refreshToken(
          account!.refreshToken, account.accessToken);
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.put(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accounts/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonBody,
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        Account account = Account.fromJson(jsonData);
        Account? account2 = await SharedPreferencesHelper.getInfo();
        account.accessToken = account2!.accessToken;
        account.refreshToken = account2.refreshToken;
        return account;
      } else {
        print("Can not update account!");
      }
    } else {
      return null;
    }
  }
}
