import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/logininfo.dart';
import 'package:thinktank_mobile/models/musicpasssource.dart';
import 'package:thinktank_mobile/models/resourceversion.dart';

class SharedPreferencesHelper {
  static const String loginInfoKey = 'loginInfo';
  static const String accInfoKey = 'accInfo';
  static const String firstUse = 'fisrtUse';
  static const String musicPassSource = 'musicPassSource';
  static const String musicPasswordLevel = 'musicPassLevel';
  static const String resourceVersionKey = 'resourceVersion';

  static Future<void> saveAccount(LoginInfo account) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountJson = jsonEncode(account.toJson());
    prefs.setString(loginInfoKey, accountJson);
  }

  static Future<void> saveInfo(Account account) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountJson = jsonEncode(account.toJson());
    prefs.setString(accInfoKey, accountJson);
  }

  static Future<void> saveResourceVersion(
      ResourceVersion resourceVersion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String resourceVerisonJson = jsonEncode(resourceVersion.toJson());
    prefs.setString(resourceVersionKey, resourceVerisonJson);
  }

  static Future<ResourceVersion?> getResourceVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? resourceVerisonJson = prefs.getString(resourceVersionKey);

    if (resourceVerisonJson != null) {
      Map<String, dynamic> versionMap = jsonDecode(resourceVerisonJson);
      return ResourceVersion.fromJson(versionMap);
    } else {
      return null;
    }
  }

  static Future<Account?> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountJson = prefs.getString(accInfoKey);

    if (accountJson != null) {
      Map<String, dynamic> accountMap = jsonDecode(accountJson);
      return Account.fromJson(accountMap);
    } else {
      return null;
    }
  }

  static Future<void> removeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(accInfoKey);
  }

  static Future<LoginInfo?> getAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountJson = prefs.getString(loginInfoKey);

    if (accountJson != null) {
      Map<String, dynamic> accountMap = jsonDecode(accountJson);
      return LoginInfo.fromJson(accountMap);
    } else {
      return null;
    }
  }

  static Future<List<MusicPasswordSource>> getMusicPasswordSources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getStringList(musicPassSource)?.first;

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      List<MusicPasswordSource> musicPasswordSources =
          jsonList.map((json) => MusicPasswordSource.fromJson(json)).toList();
      return musicPasswordSources;
    } else {
      return [];
    }
  }

  static Future<void> saveMusicPasswordSources(
      List<MusicPasswordSource> sources) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> jsonList =
        sources.map((source) => source.toJson()).toList();

    String jsonString = jsonEncode(jsonList);

    await prefs.setStringList(musicPassSource, [jsonString]);
  }

  static Future<void> saveMusicPasswordLevel(int level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(musicPasswordLevel, level.toString());
  }

  static Future<int> getMusicPasswordLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(musicPasswordLevel);
    if (json != null) {
      return int.parse(json);
    } else {
      return 0;
    }
  }

  static Future<void> removeAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(loginInfoKey);
  }

  static Future<void> saveFirstUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(firstUse, 'true');
  }

  static Future<bool> getFirstUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(firstUse);
    if (json != null) {
      return true;
    } else {
      return false;
    }
  }
}
