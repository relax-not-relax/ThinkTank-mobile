import 'dart:convert';

import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/accountinrank.dart';
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
          accountInRoomResponses: [],
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
        accountInRoomResponses: [],
      );
    }
  }

  static Future<bool> cancelRoom(int id) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.delete(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/rooms/$id,${account!.id}'),
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
            'https://thinktank-sep490.azurewebsites.net/api/rooms/$id,${account2.id}'),
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

  static Future<dynamic> enterToRoom(String code) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    var data = [
      {
        "accountId": account!.id,
        "duration": 0,
        "mark": 0,
        "pieceOfInformation": 0
      }
    ];

    String jsonBody = jsonEncode(data);
    print(jsonBody);

    final response = await http.put(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/rooms/$code'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(response.body);
      Room updatedRoom = Room.fromJson(jsonData);
      return updatedRoom;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.put(
        Uri.parse('https://thinktank-sep490.azurewebsites.net/api/rooms/$code'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
        body: jsonBody,
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        print(response.body);
        Room updatedRoom = Room.fromJson(jsonData);
        return updatedRoom;
      } else {
        final error = json.decode(response2.body)['error'];
        return error;
      }
    } else {
      final error = json.decode(response.body)['error'];
      print(error);
      return error;
    }
  }

  static Future<List<AccountInRank>> getRoomLeaderboard(String roomCode) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    List<AccountInRank> result = [];
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/rooms/$roomCode/leaderboard'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      for (var element in jsonData) {
        result.add(AccountInRank.fromJson(element));
      }
      return result;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/rooms/$roomCode/leaderboard'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        for (var element in jsonData) {
          result.add(AccountInRank.fromJson(element));
        }
        return result;
      } else {
        // final error = json.decode(response2.body)['errors'];
        return [];
      }
    } else {
      // final error = json.decode(response.body)['errors'];
      // print(error);
      return [];
    }
  }

  static Future<void> startGame(String roomCode, int time) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    List<AccountInRank> result = [];
    print('${account!.id},${roomCode},$time');
    print(
        'https://thinktank-sep490.azurewebsites.net/api/rooms/${account!.id},${roomCode},$time/started-room');
    print('Call API start game rồi');
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/rooms/${account!.id},${roomCode},$time/started-room'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/rooms/${account.id},${roomCode},$time/started-room'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        return;
      } else {
        final error = json.decode(response2.body)['error'];
        return error;
      }
    } else {
      final error = json.decode(response.body)['error'];
      print(error);
      return error;
    }
  }

  static Future<void> removeRoomDelay(String roomCode, int time) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    print('call xoa room');
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/rooms/$time,$roomCode/room-removed'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );
    print('remove room: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/rooms/$time,$roomCode/room-removed'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        return;
      } else {
        return;
      }
    } else {
      return;
    }
  }

  static Future<void> addAccountInRoom(String code, int mark) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    var data = {
      "accountId": account!.id,
      "duration": 0,
      "mark": mark,
      "pieceOfInformation": 0
    };

    String jsonBody = jsonEncode(data);
    print(jsonBody);

    final response = await http.put(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accountInRooms/$code'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
      body: jsonBody,
    );
    print("Add account in room:" + response.statusCode.toString());

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.put(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountInRooms/$code'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
        body: jsonBody,
      );
      if (response2.statusCode == 200) {
        return;
      } else {
        final error = json.decode(response2.body)['error'];
        return error;
      }
    } else {
      final error = json.decode(response.body)['error'];
      print(error);
      return error;
    }
  }

  static Future<dynamic> leaveRoom(int roomId) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.put(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/rooms/$roomId,${account!.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(response.body);
      Room updatedRoom = Room.fromJson(jsonData);
      return updatedRoom;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.put(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/rooms/$roomId,${account2.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        print(response.body);
        Room updatedRoom = Room.fromJson(jsonData);
        return updatedRoom;
      } else {
        final error = json.decode(response2.body)['error'];
        return error;
      }
    } else {
      final error = json.decode(response.body)['error'];
      print(error);
      return error;
    }
  }
}
