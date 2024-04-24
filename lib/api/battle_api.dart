import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart';
import 'package:thinktank_mobile/api/account_api.dart';
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/api/lock_manager.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/accountbattle.dart';

class BattleAPI {
  static Future<AccountBattle?> findOpponent(
      int accountId, int gameId, int coins) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s/$accountId,$gameId,$coins/opponent-of-account'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );
    print(response.statusCode);
    print(response.toString());
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      BattleAPI.removeCache(
          accountId, gameId, 20, AccountBattle.fromJson(jsonData).roomId, 90);
      return AccountBattle.fromJson(jsonData);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s/$accountId,$gameId,$coins/opponent-of-account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );
      print("code2");
      print(response2.statusCode);
      print(response2.body);
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body.toString());
        BattleAPI.removeCache(
            accountId, gameId, 20, AccountBattle.fromJson(jsonData).roomId, 90);
        return AccountBattle.fromJson(jsonData);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<bool> report(
      int accountId2, String title, String description) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    Map<String, dynamic> data = {
      "description": description,
      "accountId1": account!.id,
      "accountId2": accountId2,
      "title": title
    };

    String jsonBody = jsonEncode(data);
    print(jsonBody);
    final response = await http.post(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/reports'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      print("Sent");
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.post(
          Uri.parse('https://thinktank-sep490.azurewebsites.net/api/reports'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${account2.accessToken}',
          },
          body: jsonBody);
      if (response2.statusCode == 200) {
        print("Sent");
        return true;
      } else {
        print("Unsent");
        return false;
      }
    } else {
      print("Unsent");
      return false;
    }
  }

  static Future<void> removeCache(
      int accountId, int gameId, int coins, String roomCode, int delay) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s/$accountId,$gameId,$coins,$roomCode,$delay/account-removed'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );

    print("status ne: " + response.statusCode.toString());
    print(
        'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s/$accountId,$gameId,$coins,$roomCode,$delay/account-removed');

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s/$accountId,$gameId,$coins,$roomCode,$delay/account-removed'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );
      print("code2");
      print(response2.statusCode);
      print(response2.body);
      if (response2.statusCode == 200) {
        return;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<void> startBattle(
      String roomId, bool isUSer1, int time, int progressTime) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s/$roomId,$isUSer1,$time,$progressTime/started-room'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s/$roomId,$isUSer1,$time,$progressTime/started-room'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );
      print("code2");
      print(response2.statusCode);
      print(response2.body);
      if (response2.statusCode == 200) {
        return;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<void> remove1v1RoomDelay(String roomCode, int time) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s/$time,$roomCode/room-1vs1-removed'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s/$time,$roomCode/room-1vs1-removed'),
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

  static Future<void> addResultBattle(int coins, int winerId, int account1Id,
      int account2Id, int gameId, String roomId, DateTime startTime) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    Map<String, dynamic> data = {
      "startTime": DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(startTime),
      "coin": coins,
      "winnerId": winerId,
      "accountId1": account1Id,
      "accountId2": account2Id,
      "gameId": gameId,
      "roomOfAccountIn1vs1Id": roomId
    };

    String jsonBody = jsonEncode(data);
    print(jsonBody);
    final response = await http.put(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account!.accessToken}',
        },
        body: jsonBody);
    print('ta tut tut:' + response.statusCode.toString());
    if (response.statusCode == 200) {
      print('da add');
      //await ApiAccount.updateCoin();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.put(
          Uri.parse(
              'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${account2!.accessToken}',
          },
          body: jsonBody);
      print(response2.statusCode);
      print(response2.body);
      if (response2.statusCode == 200) {
        print('da add');
        //await ApiAccount.updateCoin();
      } else {
        return;
      }
    } else {
      return;
    }
  }

  static Future<void> addAccountBattle(int coins, int winerId, int account1Id,
      int account2Id, int gameId, String roomId, DateTime startTime) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    Map<String, dynamic> data = {
      "startTime": DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(startTime),
      "coin": coins,
      "winnerId": winerId,
      "accountId1": account1Id,
      "accountId2": account2Id,
      "gameId": gameId,
      "roomOfAccountIn1vs1Id": roomId
    };

    String jsonBody = jsonEncode(data);
    print(jsonBody);
    final response = await http.post(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account!.accessToken}',
        },
        body: jsonBody);
    print('ta tut: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      print('da add');
      //await ApiAccount.updateCoin();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.post(
          Uri.parse(
              'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1s'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${account2!.accessToken}',
          },
          body: jsonBody);
      print(response2.statusCode);
      print(response2.body);
      if (response2.statusCode == 200) {
        print('da add');
        //await ApiAccount.updateCoin();
      } else {
        return;
      }
    } else {
      return;
    }
  }
}
