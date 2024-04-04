import 'dart:convert';

import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/game_of_server.dart';
import 'package:http/http.dart' as http;

class ApiGame {
  static Future<GameOfServer> getGameById(int id) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/games/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      GameOfServer game = GameOfServer.fromJson(jsonData);
      print(game);
      return game;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse('https://thinktank-sep490.azurewebsites.net/api/games/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        print(jsonData);
        GameOfServer game = GameOfServer.fromJson(jsonData);
        print(game);
        return game;
      } else {
        return const GameOfServer(
          id: 0,
          name: "",
          amoutPlayer: 0,
          topics: [],
        );
      }
    } else {
      return const GameOfServer(
        id: 0,
        name: "",
        amoutPlayer: 0,
        topics: [],
      );
    }
  }
}
