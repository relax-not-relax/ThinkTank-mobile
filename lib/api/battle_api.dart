import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:synchronized/synchronized.dart';
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
          'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1/opponent-of-account?accountId=$accountId&gameId=$gameId&coin=$coins'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return AccountBattle.fromJson(jsonData);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accountIn1vs1/opponent-of-account?accountId=$accountId&gameId=$gameId&coin=$coins'),
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
        return AccountBattle.fromJson(jsonData);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
