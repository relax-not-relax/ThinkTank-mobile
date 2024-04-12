import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/accountbattle.dart';
import 'package:thinktank_mobile/models/friendship.dart';

class ApiFriends {
  static Future<List<Friendship>> getFriends(
      int page, int pageSize, int accountId) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/friends?Page=$page&PageSize=$pageSize&Status=2&AccountId=$accountId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/friends?Page=$page&PageSize=$pageSize&Status=2&AccountId=$accountId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
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
      } else
        return [];
    } else {
      return [];
    }
  }

  static Future<List<Friendship>> searchRequest(
      int page, int pageSize, int accountId, String userCode) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/friends?Page=$page&PageSize=$pageSize&Status=3&AccountId=$accountId&UserCode=$userCode'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/friends?Page=$page&PageSize=$pageSize&Status=3&AccountId=$accountId&UserCode=$userCode'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
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
      } else
        return [];
    } else {
      return [];
    }
  }

  static Future<List<Friendship>> searchFriends(int page, int pageSize,
      int accountId, String userCode, String userName) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/friends?Page=$page&PageSize=$pageSize&Status=1&AccountId=$accountId&UserCode=$userCode&UserName=$userCode'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/friends?Page=$page&PageSize=$pageSize&Status=1&AccountId=$accountId&UserCode=$userCode&UserName=$userCode'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
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
    } else {
      return [];
    }
  }

  static Future<Friendship?> addFriend(int accountId1, int accountId2) async {
    Map<String, dynamic> data = {
      "accountId1": accountId1,
      "accountId2": accountId2
    };
    String jsonBody = jsonEncode(data);
    Account? account = await SharedPreferencesHelper.getInfo();

    final response = await http.post(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/friends'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Friendship.fromJson(jsonData);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.post(
        Uri.parse('https://thinktank-sep490.azurewebsites.net/api/friends'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
        body: jsonBody,
      );

      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        return Friendship.fromJson(jsonData);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<void> deleteFriend(int friendId) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.delete(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/friends/$friendId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );
    if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      await http.delete(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/friends/$friendId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );
    }
  }

  static Future<Friendship?> acceptFriend(int friendShipId) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/friends/$friendShipId/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Friendship.fromJson(jsonData);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/friends/$friendShipId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        return Friendship.fromJson(jsonData);
      } else {
        return null;
      }
    } else
      return null;
  }

  static Future<dynamic> challengeFriend(int gameId, int competitorId) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1/${account!.id},$gameId,$competitorId/countervailing-mode-with-friend'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return AccountBattle.fromJson(jsonData);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1/${account2!.id},$gameId,$competitorId/countervailing-mode-with-friend'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        return AccountBattle.fromJson(jsonData);
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
