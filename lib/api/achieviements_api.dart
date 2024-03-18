import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';

class ApiAchieviements {
  static Future<void> addAchieviements(
      double duration,
      int mark,
      int level,
      int gameId,
      // int topicId,
      // int pieceOfInformation,
      int accountId,
      String authToken) async {
    Map<String, dynamic> data = {
      "duration": duration,
      "mark": mark,
      "level": level,
      "gameId": gameId,
      "accountId": accountId,
      // "topicId": 0,
      // "pieceOfInformation": 0
    };
    String jsonBody = jsonEncode(data);

    final response = await http.post(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/achievements'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account = await SharedPreferencesHelper.getInfo();
      Account? account2 = await ApiAuthentication.refreshToken(
          account!.refreshToken, account.accessToken);
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.post(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/achievements'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
        body: jsonBody,
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
      } else {
        print(response2.body);
      }
    } else {
      print(response.body);
    }
  }

  static Future<void> getLevelOfUser(int accountId, String authToken) async {
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/game-level-of-account?accountId=$accountId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    print("get level status: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      int? musicPasswordLevel;
      int? anonymousLEvel;
      int? flipCardLevel;
      if (jsonData.toString() == '[]') {
        SharedPreferencesHelper.saveAnonymousLevel(1);
        SharedPreferencesHelper.saveMusicPasswordLevel(1);
      } else {
        for (var element in jsonData) {
          switch (element['gameId']) {
            case 1:
              flipCardLevel = element['level'] + 1;
              print('level $jsonData');
              break;

            case 2:
              musicPasswordLevel = element['level'] + 1;
              print('level $jsonData');
              SharedPreferencesHelper.saveMusicPasswordLevel(
                  musicPasswordLevel ?? 1);
              break;
            case 5:
              anonymousLEvel = element['level'] + 1;
              print('level $jsonData');
              SharedPreferencesHelper.saveAnonymousLevel(anonymousLEvel ?? 1);
              break;
          }
        }
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account = await SharedPreferencesHelper.getInfo();
      Account? account2 = await ApiAuthentication.refreshToken(
          account!.refreshToken, account.accessToken);
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accounts/game-level-of-account?accountId=$accountId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        int? musicPasswordLevel;
        int? anonymousLEvel;
        int? flipCardLevel;
        if (jsonData.toString() == '[]') {
          SharedPreferencesHelper.saveAnonymousLevel(1);
          SharedPreferencesHelper.saveMusicPasswordLevel(1);
        } else {
          for (var element in jsonData) {
            switch (element['gameId']) {
              case 1:
                flipCardLevel = element['level'] + 1;
                print('level $jsonData');
                break;

              case 2:
                musicPasswordLevel = element['level'] + 1;
                print('level $jsonData');
                SharedPreferencesHelper.saveMusicPasswordLevel(
                    musicPasswordLevel ?? 1);
                break;
              case 5:
                anonymousLEvel = element['level'] + 1;
                print('level $jsonData');
                SharedPreferencesHelper.saveAnonymousLevel(anonymousLEvel ?? 1);
                break;
            }
          }
        }
      } else {
        print(response2.body);
      }
    } else {
      print(response.body);
    }
  }
}
