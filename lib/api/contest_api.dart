import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/assets_api.dart';
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/models/findanounymous_assets.dart';
import 'package:path_provider/path_provider.dart';

class ContestsAPI {
  static Future<AssetOfContest> convertFindAnonymous(
      AssetOfContest assetOfContest, String path) async {
    List<String> s = assetOfContest.value.split(';');
    assetOfContest.value = s[0] + ';' + path;
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
            'https://thinktank-sep490.azurewebsites.net/api/contests?Page=1&PageSize=10000&ContestStatus=1'),
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
        for (var element in jsonData['results']) {
          Contest contest = Contest.fromJson(element);
          if (!contestInDevice.any((element) => element.id == contest.id)) {
            print('zo trong');
            print(contest.gameId);
            if (contest.gameId == 1) {
              for (var as in contest.assetOfContests) {
                String value = await AssetsAPI.saveImageToDevice(
                    as.value, "Contest" + as.id.toString());
                as.value = value;
                assetsContest.add(as);
              }
            }
            if (contest.gameId == 4) {
              print('zo sau');
              for (var as in contest.assetOfContests) {
                print('zo sau nua');
                String value = await AssetsAPI.saveImageToDevice(
                    as.value, "Contest" + as.id.toString());
                as.value = value;
                assetsContest.add(as);
              }
            }
            if (contest.gameId == 5) {
              print('anonymous');
              for (var as in contest.assetOfContests) {
                String s = await AssetsAPI.saveImageToDevice(
                    as.value.split(';')[1], "Contest" + as.id.toString());
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
        Account? account = await SharedPreferencesHelper.getInfo();
        Account? account2 = await ApiAuthentication.refreshToken(
            account!.refreshToken, account.accessToken);
        SharedPreferencesHelper.saveInfo(account2!);
        final response2 = await http.get(
          Uri.parse(
              'https://thinktank-sep490.azurewebsites.net/api/contests?Page=1&PageSize=10000&ContestStatus=1'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${account.accessToken}',
          },
        );
        List<Contest> result = [];

        if (response2.statusCode == 200) {
          final jsonData = json.decode(response2.body);
          print("Messi" + jsonData.toString());
          List<AssetOfContest> assetsContest = [];
          for (var element in jsonData['results']) {
            Contest contest = Contest.fromJson(element);
            if (!contestInDevice.any((element) => element.id == contest.id)) {
              switch (contest.gameId) {
                case 1:
                  {
                    for (var as in contest.assetOfContests) {
                      await AssetsAPI.saveImageToDevice(
                          as.value, "Contest" + as.id.toString());
                      assetsContest.add(as);
                    }
                    break;
                  }

                case 4:
                  {
                    for (var as in contest.assetOfContests) {
                      await AssetsAPI.saveImageToDevice(
                          as.value, "Contest" + as.id.toString());
                      assetsContest.add(as);
                    }
                    break;
                  }

                case 5:
                  {
                    for (var as in contest.assetOfContests) {
                      String s = await AssetsAPI.saveImageToDevice(
                          as.value.split(';')[1], "Contest" + as.id.toString());
                      assetsContest.add(await convertFindAnonymous(as, s));
                    }
                    break;
                  }
              }
              contest.assetOfContests = [];
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
      return;
    }
  }
}
