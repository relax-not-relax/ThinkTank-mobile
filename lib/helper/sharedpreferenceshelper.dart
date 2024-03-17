import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/findanounymous_assets.dart';
import 'package:thinktank_mobile/models/image_resource.dart';
import 'package:thinktank_mobile/models/logininfo.dart';
import 'package:thinktank_mobile/models/musicpasssource.dart';
import 'package:thinktank_mobile/models/notification_item.dart';
import 'package:thinktank_mobile/models/resourceversion.dart';

class SharedPreferencesHelper {
  static const String loginInfoKey = 'loginInfo';
  static const String accInfoKey = 'accInfo';
  static const String firstUse = 'fisrtUse';
  static const String musicPassSource = 'musicPassSource';
  static const String imageResourceKey = 'imageVersion';
  static const String musicPasswordLevel = 'musicPassLevel';
  static const String flipCardLevel = 'flipCardLevel';
  static const String flipCardTime = 'flipCardTime';
  static const String imageSource = 'imageSource';
  static const String resourceVersionKey = 'resourceVersion';
  static const String anonymousResourcenKey = 'anonymousResourcenKey';

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

  static Future<void> saveResourceVersion(int resourceVersion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(resourceVersionKey, resourceVersion);
  }

  static Future<int> getResourceVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? resourceVerisonJson = prefs.getInt(resourceVersionKey);

    if (resourceVerisonJson != null) {
      return resourceVerisonJson;
    } else {
      return 0;
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

  static Future<List<ImageResource>> getImagesSources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getStringList(imageSource)?.first;

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      List<ImageResource> imageSources =
          jsonList.map((json) => ImageResource.fromJson(json)).toList();
      return imageSources;
    } else {
      return [];
    }
  }

  static Future<void> saveImageSources(List<ImageResource> sources) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> jsonList =
        sources.map((source) => source.toJson()).toList();

    String jsonString = jsonEncode(jsonList);

    await prefs.setStringList(imageSource, [jsonString]);
  }

  static Future<void> saveFLipCardLevel(int level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(flipCardLevel, level.toString());
  }

  static Future<int> getFLipCardLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(flipCardLevel);
    if (json != null) {
      return int.parse(json);
    } else {
      return 0;
    }
  }

  static Future<void> saveFlipCardTime(double time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(flipCardTime, time.toString());
  }

  static Future<double> getFLipCardTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(flipCardTime);
    if (json != null) {
      return double.parse(json);
    } else {
      return 0;
    }
  }

  static Future<void> saveNotifications(
      List<NotificationItem> notifications) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> jsonList =
        notifications.map((notification) => notification.toJson()).toList();
    String notificationsString = json.encode(jsonList);
    await prefs.setString('notifications', notificationsString);
  }

  static Future<void> saveImageResoure(List<String> flipcardResource) async {
    if (flipcardResource.isEmpty) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? result = prefs.getStringList(imageResourceKey);
    if (result != null && result.isNotEmpty) {
      result.addAll(flipcardResource);
      await prefs.setStringList(imageResourceKey, result);
    } else {
      await prefs.setStringList(imageResourceKey, flipcardResource);
    }
  }

  static Future<void> saveAnonymousResoure(
      List<FindAnonymousAsset> resource) async {
    if (resource.isEmpty) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? anonymousString = prefs.getString(anonymousResourcenKey);
    List<dynamic> jsonList;
    List<FindAnonymousAsset> anonymousAssets = [];
    if (anonymousString != null) {
      jsonList = json.decode(anonymousString) as List<dynamic>;
      anonymousAssets = jsonList
          .map((jsonItem) =>
              FindAnonymousAsset.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
    }

    anonymousAssets.addAll(resource);
    List<Map<String, dynamic>> jsonList2 =
        anonymousAssets.map((assets) => assets.toJson()).toList();
    String assets = json.encode(jsonList2);
    await prefs.setString(anonymousResourcenKey, assets);
  }

  static Future<List<FindAnonymousAsset>> getAnonymousAssets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assetString = prefs.getString(anonymousResourcenKey);
    if (assetString != null) {
      try {
        List<dynamic> jsonList = json.decode(assetString) as List<dynamic>;

        List<FindAnonymousAsset> assets = jsonList
            .map((jsonItem) =>
                FindAnonymousAsset.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
        return assets;
      } catch (e) {
        print('Error parsing notifications from SharedPreferences: $e');
        return [];
      }
    } else {
      return [];
    }
  }

  static Future<List<String>> getImageResource() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? result = prefs.getStringList(imageResourceKey);
    return result ?? [];
  }

  static Future<List<NotificationItem>> getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notificationsString = prefs.getString('notifications');
    if (notificationsString != null) {
      try {
        List<dynamic> jsonList =
            json.decode(notificationsString) as List<dynamic>;

        List<NotificationItem> notifications = jsonList
            .map((jsonItem) =>
                NotificationItem.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
        return notifications;
      } catch (e) {
        print('Error parsing notifications from SharedPreferences: $e');
        return [];
      }
    } else {
      return [];
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
