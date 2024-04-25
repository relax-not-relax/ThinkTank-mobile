import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/account_api.dart';
import 'package:thinktank_mobile/api/assets_api.dart';
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/accountincontest.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/models/findanounymous_assets.dart';
import 'package:path_provider/path_provider.dart';

class ContestsAPI {
  static Future<String> saveAudioToDevice(String audioUrl, String name) async {
    try {
      final response = await http.get(Uri.parse(audioUrl));
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDir.path}/audio$name.mp3';
      final File imageFile = File(filePath);
      await imageFile.writeAsBytes(response.bodyBytes);
      print(filePath);
      return filePath;
    } catch (e) {
      return '';
    }
  }

  static Future<AccountInContest?> checkAccountInContest(int contestId) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    if (account == null) return null;
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accountInContests?AccountId=${account.id}&ContestId=$contestId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final data = jsonData['results'];
      int count = int.parse(jsonData['totalNumberOfRecords'].toString());
      if (count > 0) {
        return AccountInContest.fromJson(data[0]);
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountInContests?AccountId=${account2!.id}&ContestId=$contestId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        final data = jsonData['results'];
        int count = int.parse(['totalNumberOfRecords'].toString());
        if (count > 0) {
          return AccountInContest.fromJson(data[0]);
        } else {
          return null;
        }
      } else {
        print("Get account in contest error");
        return null;
      }
    } else {
      print("Get account in contest error");
      return null;
    }
  }

  static Future<void> minusCoin(int contestId) async {
    Account? account = await SharedPreferencesHelper.getInfo();

    if (account == null) return null;
    Map<String, dynamic> data = {
      "accountId": account.id,
      "contestId": contestId
    };
    String jsonBody = jsonEncode(data);
    print('contest: ' + jsonBody);
    final response = await http.post(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountInContests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account.accessToken}',
        },
        body: jsonBody);
    print('status contest: ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.post(
          Uri.parse(
              'https://thinktank-sep490.azurewebsites.net/api/accountInContests'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${account2!.accessToken}',
          },
          body: jsonBody);
      if (response2.statusCode == 200) {
        return;
      } else {
        return;
      }
    } else {
      return;
    }
  }

  static Future<List<AccountInContest>?> getAccountInContest(
      int contestId, int index, int pageSize) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    if (account == null) return [];
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/contests/$contestId/leaderboard?Page=$index&PageSize=$pageSize&SortType=1'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final data = jsonData['results'];
      print(data.toString());
      List<AccountInContest> results = [];
      int count = int.parse(jsonData['totalNumberOfRecords'].toString());
      if (count > 0) {
        for (var element in data) {
          AccountInContest ac = AccountInContest.fromJson(element);
          ac.userName = element['fullName'].toString();
          results.add(ac);
        }
        return results;
      } else {
        return [];
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/contests/$contestId/leaderboard?Page=$index&PageSize=$pageSize&SortType=1'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );

      if (response2.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['results'];
        List<AccountInContest> results = [];
        int count = int.parse(jsonData['totalNumberOfRecords'].toString());
        if (count > 0) {
          for (var element in data) {
            AccountInContest ac = AccountInContest.fromJson(element);
            ac.userName = element['fullName'].toString();
            results.add(ac);
          }
          return results;
        } else {
          return [];
        }
      } else {
        print("Get account in contest error");
        return [];
      }
    }
  }

  static Future<void> addAccountInContest(
      double duration, int mark, int contestId) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    if (account == null) return;
    Map<String, dynamic> data = {
      "duration": duration,
      "mark": mark,
      "accountId": account.id,
      "contestId": contestId
    };
    String jsonBody = jsonEncode(data);
    print(jsonBody);

    final response = await http.put(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accountInContests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      // await ApiAccount.updateCoin();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.put(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountInContests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
        body: jsonBody,
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response.body);
        //  await ApiAccount.updateCoin();
        print(jsonData);
      } else {
        print(response2.body);
      }
    } else {
      print(response.body);
    }
  }

  static Future<AssetOfContest> convertFindAnonymous(
      AssetOfContest assetOfContest, String path) async {
    List<String> s = assetOfContest.value.split(';');
    assetOfContest.value = '${s[0]};$path';
    return assetOfContest;
  }

  static Future<void> getContets() async {
    try {
      Account? account = await SharedPreferencesHelper.getInfo();
      if (account == null) {
        print("Get contest Error, Account null");
        return;
      }
      print('get contest');
      final response = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/contests?Page=1&PageSize=10000&ContestStatus=2'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account.accessToken}',
        },
      );
      List<Contest> result = [];
      List<Contest> contestInDevice =
          await SharedPreferencesHelper.getContests();
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<AssetOfContest> assetsContest = [];
        print(jsonData['results']);
        for (var element in jsonData['results']) {
          print(element);
          print('zo yo');
          Contest contest = Contest.fromJson(element);
          print(contestInDevice.length);
          print(!contestInDevice.any((ele) => ele.id == contest.id));
          if (!contestInDevice.any((ele) => ele.id == contest.id)) {
            print('zo trong');
            print(contest.gameId);
            if (contest.gameId == 1) {
              for (var as in contest.assetOfContests) {
                String value = await AssetsAPI.saveImageToDevice(
                    as.value, "Contest${as.id}");
                as.value = value;
                assetsContest.add(as);
              }
            }
            if (contest.gameId == 2) {
              for (var as in contest.assetOfContests) {
                String value = await AssetsAPI.saveAudioToDevice(
                    as.value, "Contest${as.id}");
                as.value = value;
                print(as.value);
                assetsContest.add(as);
              }
            }
            if (contest.gameId == 4) {
              print('zo sau');
              for (var as in contest.assetOfContests) {
                print('zo sau nua');
                String value = await AssetsAPI.saveImageToDevice(
                    as.value, "Contest${as.id}");
                as.value = value;
                assetsContest.add(as);
              }
            }
            if (contest.gameId == 5) {
              print('anonymous');
              for (var as in contest.assetOfContests) {
                String s = await AssetsAPI.saveImageToDevice(
                    as.value.split(';')[1], "Contest${as.id}");
                assetsContest.add(await convertFindAnonymous(as, s));
              }
            }
            contest.assetOfContests.clear();
            result.add(contest);
          }
        }
        await SharedPreferencesHelper.saveContestInfo(result);
        await SharedPreferencesHelper.saveContestResource(assetsContest);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        Account? account2 = await ApiAuthentication.refreshToken();
        final response2 = await http.get(
          Uri.parse(
              'https://thinktank-sep490.azurewebsites.net/api/contests?Page=1&PageSize=10000&ContestStatus=2'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${account2!.accessToken}',
          },
        );
        List<Contest> result = [];

        if (response2.statusCode == 200) {
          final jsonData = json.decode(response2.body);
          print("Messi$jsonData");
          List<AssetOfContest> assetsContest = [];

          for (var element in jsonData['results']) {
            print(element);
            print('zo yo');
            Contest contest = Contest.fromJson(element);
            print(contestInDevice.length);
            print(!contestInDevice.any((ele) => ele.id == contest.id));
            if (!contestInDevice.any((ele) => ele.id == contest.id)) {
              print('zo trong');
              print(contest.gameId);
              if (contest.gameId == 1) {
                for (var as in contest.assetOfContests) {
                  String value = await AssetsAPI.saveImageToDevice(
                      as.value, "Contest${as.id}");
                  as.value = value;

                  assetsContest.add(as);
                }
              }
              if (contest.gameId == 2) {
                for (var as in contest.assetOfContests) {
                  String value = await AssetsAPI.saveAudioToDevice(
                      as.value, "Contest${as.id}");
                  as.value = value;
                  assetsContest.add(as);
                }
              }
              if (contest.gameId == 4) {
                print('zo sau');
                for (var as in contest.assetOfContests) {
                  print('zo sau nua');
                  String value = await AssetsAPI.saveImageToDevice(
                      as.value, "Contest${as.id}");
                  as.value = value;
                  assetsContest.add(as);
                }
              }
              if (contest.gameId == 5) {
                print('anonymous');
                for (var as in contest.assetOfContests) {
                  String s = await AssetsAPI.saveImageToDevice(
                      as.value.split(';')[1], "Contest${as.id}");
                  assetsContest.add(await convertFindAnonymous(as, s));
                }
              }
              contest.assetOfContests.clear();
              result.add(contest);
            }
          }
          await SharedPreferencesHelper.saveContestInfo(result);
          await SharedPreferencesHelper.saveContestResource(assetsContest);
        }
      } else {
        print(response.body);
        return;
      }
    } catch (e) {
      print(e.toString());
      return;
    }
  }
}
