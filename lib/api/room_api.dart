import 'dart:convert';

import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/room.dart';
import 'package:http/http.dart' as http;

class ApiRoom {
  static Future<Room> createRoom(
      String name, int amountPlayer, int topicId) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    Map<String, dynamic> request = {
      "name": name,
      "amountPlayer": amountPlayer,
      "topicId": topicId,
      "accountId": account!.id,
    };
    String jsonBody = jsonEncode(request);
    final response = await http.post(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/rooms'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      Room room = Room.fromJson(jsonData);
      print(room.toString());
      return room;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      Map<String, dynamic> request = {
        "name": name,
        "amountPlayer": amountPlayer,
        "topicId": topicId,
        "accountId": account2.id,
      };
      String jsonBody = jsonEncode(request);
      final response2 = await http.post(
        Uri.parse('https://thinktank-sep490.azurewebsites.net/api/rooms'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account.accessToken}',
        },
        body: jsonBody,
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        print(jsonData);
        Room room = Room.fromJson(jsonData);
        print(room);
        return room;
      } else {
        return Room(
          id: 0,
          name: name,
          code: "",
          amountPlayer: amountPlayer,
          startTime: "",
          endTime: "",
          status: false,
          topicId: topicId,
          topicName: "",
          gameName: "",
          accountIn1Vs1Responses: [],
        );
      }
    } else {
      return Room(
        id: 0,
        name: name,
        code: "",
        amountPlayer: amountPlayer,
        startTime: "",
        endTime: "",
        status: false,
        topicId: topicId,
        topicName: "",
        gameName: "",
        accountIn1Vs1Responses: [],
      );
    }
  }

  static Future<bool> cancelRoom(int id) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.delete(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/rooms/$id?accountId=${account!.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      print("Cancel room successfully!");
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.delete(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/rooms/$id?accountId=${account2.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        print("Cancel room successfully!");
        return true;
      } else {
        final error = json.decode(response2.body)['error'];
        print(error);
        return false;
      }
    } else {
      final error = json.decode(response.body)['error'];
      print(error);
      return false;
    }
  }
}
