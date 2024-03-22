import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/achievement.dart';

class ApiChallenges {
  static Future<List<Challenge>> getChallenges() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/challenges?AccountId=${account!.id}&Status=1'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    List<Challenge> result = [];

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      for (var element in jsonData) {
        result.add(Challenge.fromJson(element));
      }
      return result;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account = await SharedPreferencesHelper.getInfo();
      Account? account2 = await ApiAuthentication.refreshToken(
          account!.refreshToken, account.accessToken);
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/challenges?AccountId=${account!.id}&Status=1'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response.body);
        for (var element in jsonData) {
          result.add(Challenge.fromJson(element));
        }
        return result;
      } else {
        print(response2.body);
        return result;
      }
    } else {
      print(response.body);
      return result;
    }
  }
}
