import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/friendship.dart';

class ApiFriends {
  static Future<List<Friendship>> getFriends(
      int page, int pageSize, int accountId, String authToken) async {
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/friends?Page=$page&PageSize=$pageSize&AccountId1=$accountId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final jsonList = jsonData['results'];
      List<Friendship> list = [];
      for (var element in jsonList) {
        list.add(
          Friendship(
            id: element['id'],
            status: element['status'],
            accountId1: element['accountId1'],
            accountId2: element['accountId2'],
            userName1: element['userName1'],
            avatar1: element['avatar1'],
            userName2: element['userName2'],
            avatar2: element['avatar2'],
          ),
        );
      }
      return list;
    } else {
      return [];
    }
  }

  static Future<Friendship?> addFriend(
      int accountId1, int accountId2, String authToken) async {
    Map<String, dynamic> data = {
      "accountId1": accountId1,
      "accountId2": accountId2
    };
    String jsonBody = jsonEncode(data);

    final response = await http.post(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/friends'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Friendship.fromJson(jsonData);
    } else {
      return null;
    }
  }
}
