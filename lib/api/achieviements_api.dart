import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/accountinrank.dart';
import 'package:thinktank_mobile/models/game_leaderboard.dart';

class ApiAchieviements {
  static Future<void> addAchieviements(double duration, int mark, int level,
      int gameId, int pieceOfInformation) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    Map<String, dynamic> data = {
      "duration": duration,
      "mark": mark,
      "level": level,
      "accountId": account!.id,
      "gameId": gameId,
      "pieceOfInformation": pieceOfInformation
    };
    String jsonBody = jsonEncode(data);
    print(jsonBody);

    final response = await http.post(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/achievements'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
      body: jsonBody,
    );
    print("Achive" + response.statusCode.toString());
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.post(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/achievements'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
        body: jsonBody,
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
      } else {
        return null;
      }
    } else {
      print(response.body);
    }
  }

  static Future<GameLeaderboardResponse> getLeaderBoard(
      int gameId, int pageIndex, int pageSize) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    if (account == null)
      return const GameLeaderboardResponse(
        accounts: [],
        totalNumberOfRecords: 0,
      );
    List<AccountInRank> result = [];
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/achievements/$gameId/leaderboard?Page=$pageIndex&PageSize=$pageSize'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final total = jsonData['totalNumberOfRecords'] as int;
      for (var element in jsonData['results']) {
        result.add(AccountInRank.fromJson(element));
      }
      GameLeaderboardResponse leaderboardResponse = GameLeaderboardResponse(
          accounts: result, totalNumberOfRecords: total);
      return leaderboardResponse;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/achievements/$gameId/leaderboard?Page=$pageIndex&PageSize=$pageSize'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        final total = jsonData['totalNumberOfRecords'] as int;
        for (var element in jsonData['results']) {
          result.add(AccountInRank.fromJson(element));
        }
        GameLeaderboardResponse leaderboardResponse = GameLeaderboardResponse(
            accounts: result, totalNumberOfRecords: total);
        return leaderboardResponse;
      } else {
        return const GameLeaderboardResponse(
          accounts: [],
          totalNumberOfRecords: 0,
        );
      }
    } else {
      return const GameLeaderboardResponse(
        accounts: [],
        totalNumberOfRecords: 0,
      );
    }
  }

  static Future<void> getLevelOfUser(int accountId, String authToken) async {
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/$accountId/game-level-of-account'),
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
      int? imgWalkthrougLevel;
      print(jsonData.toString());
      SharedPreferencesHelper.saveAnonymousLevel(1);
      SharedPreferencesHelper.saveMusicPasswordLevel(1);
      SharedPreferencesHelper.saveFLipCardLevel(1);
      SharedPreferencesHelper.saveImagesWalkthroughLevel(1);
      if (jsonData.toString() == '[]') {
        SharedPreferencesHelper.saveAnonymousLevel(1);
        SharedPreferencesHelper.saveMusicPasswordLevel(1);
        SharedPreferencesHelper.saveFLipCardLevel(1);
        SharedPreferencesHelper.saveImagesWalkthroughLevel(1);
      } else {
        for (var element in jsonData) {
          switch (element['gameId']) {
            case 1:
              flipCardLevel = element['level'] + 1;
              print('level $jsonData');
              SharedPreferencesHelper.saveFLipCardLevel(flipCardLevel ?? 1);
              break;
            case 2:
              musicPasswordLevel = element['level'] + 1;
              print('level $jsonData');
              SharedPreferencesHelper.saveMusicPasswordLevel(
                  musicPasswordLevel ?? 1);
              break;
            case 4:
              imgWalkthrougLevel = element['level'] + 1;
              print('level $jsonData');
              SharedPreferencesHelper.saveImagesWalkthroughLevel(
                  imgWalkthrougLevel ?? 1);
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
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accounts/$accountId/game-level-of-account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        int? musicPasswordLevel;
        int? anonymousLEvel;
        int? flipCardLevel;
        int? imgWalkthrougLevel;
        SharedPreferencesHelper.saveAnonymousLevel(1);
        SharedPreferencesHelper.saveMusicPasswordLevel(1);
        SharedPreferencesHelper.saveFLipCardLevel(1);
        SharedPreferencesHelper.saveImagesWalkthroughLevel(1);
        if (jsonData.toString() == '[]') {
          SharedPreferencesHelper.saveAnonymousLevel(1);
          SharedPreferencesHelper.saveMusicPasswordLevel(1);
          SharedPreferencesHelper.saveFLipCardLevel(1);
          SharedPreferencesHelper.saveImagesWalkthroughLevel(1);
        } else {
          for (var element in jsonData) {
            switch (element['gameId']) {
              case 1:
                flipCardLevel = element['level'] + 1;
                print('level $jsonData');
                SharedPreferencesHelper.saveFLipCardLevel(flipCardLevel ?? 1);
                break;
              case 2:
                musicPasswordLevel = element['level'] + 1;
                print('level $jsonData');
                SharedPreferencesHelper.saveMusicPasswordLevel(
                    musicPasswordLevel ?? 1);
                break;
              case 4:
                imgWalkthrougLevel = element['level'] + 1;
                print('level $jsonData');
                SharedPreferencesHelper.saveImagesWalkthroughLevel(
                    imgWalkthrougLevel ?? 1);
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
