import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/logininfo.dart';

class SharedPreferencesHelper {
  static const String loginInfoKey = 'loginInfo';
  static const String accInfoKey = 'accInfo';
  static const String firstUse = 'fisrtUse';

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
