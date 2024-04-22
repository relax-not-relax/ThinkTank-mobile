import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/models/findanounymous_assets.dart';
import 'package:thinktank_mobile/models/icon.dart';
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
  static const String imagesWalkthroughLevel = 'imagesWalkthroughLevel';
  static const String imagesWalkthroughTime = 'imagesWalkthroughTime';
  static const String imageSource = 'imageSource';
  static const String anonymousLevel = 'anonymousLevel';
  static const String resourceVersionKey = 'resourceVersion';
  static const String anonymousResourcenKey = 'anonymousResourcenKey';
  static const String contestsResourcenKey = 'contestsResourcenKey';
  static const String contestsInfoKey = 'contestsInfoKey';
  static const String iconsData = 'iconsData';
  static const String isMissionCompleted = 'isMissionCompleted';

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

  static Future<void> saveCheckMisson(bool isCompleted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isMissionCompleted, isCompleted);
  }

  static Future<bool> getCheckMission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isCompleted = prefs.getBool(isMissionCompleted);

    return isCompleted!;
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

  static Future<void> removeAllofLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(accInfoKey);
    prefs.remove(anonymousLevel);
    prefs.remove(flipCardLevel);
    prefs.remove(imagesWalkthroughLevel);
    prefs.remove(musicPasswordLevel);
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
    String? jsonString = prefs.getString(musicPassSource);
    print(jsonString);

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      print('lenght' + jsonList.length.toString());
      List<MusicPasswordSource> musicPasswordSources =
          jsonList.map((json) => MusicPasswordSource.fromJson(json)).toList();
      return musicPasswordSources;
    } else {
      print('khong get ra');
      return [];
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

  static Future<void> removeImageResoure(
      List<ImageResource> flipcardResource) async {
    print('remove1' + flipcardResource.length.toString());
    if (flipcardResource.isEmpty) return;
    List<ImageResource> listResource = await getImageResourceObject();
    print('remove2' + listResource.length.toString());
    if (listResource.isNotEmpty) {
      listResource.removeWhere(
          (element) => flipcardResource.any((ele) => ele.id == element.id));
    }
    print('remove3' + listResource.length.toString());
    await saveAllImageResoure(listResource);
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

  static Future<void> saveImagesWalkthroughLevel(int level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(imagesWalkthroughLevel, level.toString());
  }

  static Future<int> getImagesWalkthroughLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(imagesWalkthroughLevel);
    if (json != null) {
      return int.parse(json);
    } else {
      return 0;
    }
  }

  static Future<void> saveImagesWalkthroughTime(double time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(imagesWalkthroughTime, time.toString());
  }

  static Future<double> getImagesWalkthroughTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(imagesWalkthroughTime);
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

  static Future<void> saveImageResoure(
      List<ImageResource> flipcardResource) async {
    if (flipcardResource.isEmpty) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? result = prefs.getStringList(imageResourceKey);
    if (result != null && result.isNotEmpty) {
      for (var element in flipcardResource) {
        print(element.toJson().toString());
        result.add(json.encode(element.toJson()));
      }
      await prefs.setStringList(imageResourceKey, result);
      print(result.toString());
    } else {
      List<String>? result2 = [];
      for (var element in flipcardResource) {
        print(element.toJson().toString());
        result2.add(json.encode(element.toJson()));
      }
      print(result2.toString());
      await prefs.setStringList(imageResourceKey, result2);
    }
  }

  static Future<void> saveAllImageResoure(
      List<ImageResource> flipcardResource) async {
    if (flipcardResource.isEmpty) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? result2 = [];
    for (var element in flipcardResource) {
      print(element.toJson().toString());
      result2.add(json.encode(element.toJson()));
    }
    await prefs.setStringList(imageResourceKey, result2);
  }

  static Future<void> removeAnonymousResoure(
      List<FindAnonymousAsset> resource) async {
    if (resource.isEmpty) return;
    List<FindAnonymousAsset> listResource = await getAnonymousAssets();
    listResource
        .removeWhere((element) => resource.any((ele) => ele.id == element.id));
    await saveAllAnonymousResoure(listResource);
  }

  static Future<void> saveAllAnonymousResoure(
      List<FindAnonymousAsset> resource) async {
    if (resource.isEmpty) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList2 =
        resource.map((assets) => assets.toJson()).toList();
    String assets = json.encode(jsonList2);
    await prefs.setString(anonymousResourcenKey, assets);
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

  static Future<void> saveContestResource(List<AssetOfContest> resource) async {
    if (resource.isEmpty) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? contestString = prefs.getString(contestsResourcenKey);
    List<dynamic> jsonList;
    List<AssetOfContest> contestAssets = [];
    if (contestString != null) {
      jsonList = json.decode(contestString) as List<dynamic>;
      contestAssets = jsonList
          .map((jsonItem) =>
              AssetOfContest.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
    }

    contestAssets.addAll(resource);
    List<Map<String, dynamic>> jsonList2 =
        contestAssets.map((assets) => assets.toJson()).toList();
    String assets = json.encode(jsonList2);
    await prefs.setString(contestsResourcenKey, assets);
  }

  static Future<void> saveContestInfo(List<Contest> resource) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? contestString = prefs.getString(contestsInfoKey);
    List<dynamic> jsonList;
    List<Contest> contests = [];
    if (contestString != null) {
      jsonList = json.decode(contestString) as List<dynamic>;
      contests = jsonList
          .map((jsonItem) => Contest.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
    }

    contests.addAll(resource);
    List<Map<String, dynamic>> jsonList2 =
        contests.map((assets) => assets.toJson()).toList();
    String assets = json.encode(jsonList2);
    await prefs.setString(contestsInfoKey, assets);
  }

  static Future<List<Contest>> getContests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assetString = prefs.getString(contestsInfoKey);
    if (assetString != null) {
      try {
        List<dynamic> jsonList = json.decode(assetString) as List<dynamic>;

        List<Contest> assets = jsonList
            .map((jsonItem) =>
                Contest.fromJson(jsonItem as Map<String, dynamic>))
            .toList();

        return assets
            .where((element) =>
                !DateTime.parse(element.startTime).isAfter(DateTime.now()) &&
                DateTime.parse(element.endTime).isAfter(DateTime.now()))
            .toList();
      } catch (e) {
        print('Error parsing notifications from SharedPreferences: $e');
        return [];
      }
    } else {
      return [];
    }
  }

  static Future<List<AssetOfContest>> getAllContestAssets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assetString = prefs.getString(contestsResourcenKey);
    if (assetString != null) {
      try {
        List<dynamic> jsonList = json.decode(assetString) as List<dynamic>;

        List<AssetOfContest> assets = jsonList
            .map((jsonItem) =>
                AssetOfContest.fromJson(jsonItem as Map<String, dynamic>))
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
    if (result != null) {
      List<String> newResult = [];
      for (var element in result) {
        ImageResource img =
            ImageResource.fromJson(json.decode(element.toString()));
        newResult.add(img.value);
      }
      return newResult;
    } else {
      return [];
    }
  }

  static Future<List<ImageResource>> getImageResourceObject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? result = prefs.getStringList(imageResourceKey);
    if (result != null) {
      List<ImageResource> newResult = [];
      for (var element in result) {
        newResult.add(ImageResource.fromJson(json.decode(element.toString())));
      }
      return newResult;
    } else {
      return [];
    }
  }

  static Future<List<String>> getImageResourceByTopicId(int topicId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? result = prefs.getStringList(imageResourceKey);
    if (result != null) {
      List<String> newResult = [];
      for (var element in result) {
        ImageResource img =
            ImageResource.fromJson(json.decode(element.toString()));
        if (img.topicId == topicId) {
          newResult.add(img.value);
        }
      }
      return newResult;
    } else {
      return [];
    }
  }

  static Future<bool> checkTopic(int topicId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? result = prefs.getStringList(imageResourceKey);
    if (result != null) {
      for (var element in result) {
        ImageResource img =
            ImageResource.fromJson(json.decode(element.toString()));
        if (img.topicId == topicId) {
          print('debugbug' + img.id.toString());
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
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

  static Future<void> saveMusicPasswordSources(
      List<MusicPasswordSource> sources) async {
    if (sources.isEmpty) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> jsonList =
        sources.map((source) => source.toJson()).toList();

    String jsonString = jsonEncode(jsonList);

    await prefs.setString(musicPassSource, jsonString);
    print(jsonString);
  }

  static Future<void> removeMusicPasswordSources(
      List<MusicPasswordSource> sources) async {
    if (sources.isEmpty) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<MusicPasswordSource> listSource = await getMusicPasswordSources();
    listSource
        .removeWhere((element) => sources.any((ele) => ele.id == element.id));

    List<Map<String, dynamic>> jsonList =
        listSource.map((listSource) => listSource.toJson()).toList();
    String jsonString = jsonEncode(jsonList);
    await prefs.setString(musicPassSource, jsonString);
  }

  static Future<void> saveMusicPasswordLevel(int level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(musicPasswordLevel, level.toString());
  }

  static Future<void> saveAnonymousLevel(int level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(anonymousLevel, level.toString());
  }

  static Future<int> getAnonymousLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(anonymousLevel);
    if (json != null) {
      return int.parse(json);
    } else {
      return 0;
    }
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

  static Future<List<IconApp>> getIconSources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getStringList(iconsData)?.first;
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      List<IconApp> iconsDatas =
          jsonList.map((json) => IconApp.fromJson(json)).toList();
      return iconsDatas;
    } else {
      return [];
    }
  }

  static Future<void> saveIconSources(List<IconApp> sources) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> jsonList =
        sources.map((source) => source.toJson()).toList();

    String jsonString = jsonEncode(jsonList);

    await prefs.setStringList(iconsData, [jsonString]);
  }
}
