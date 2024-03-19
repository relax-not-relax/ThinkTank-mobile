import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/notification_item.dart';

class ApiNotification {
  static Future<List<NotificationItem>> getNotifications(
      int id, String authToken) async {
    List<NotificationItem> notifications = [];
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/notifications?AccountId=$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final results = jsonData['results'];
      notifications = results
          .map<NotificationItem>((item) => NotificationItem.fromJson(item))
          .toList();

      return notifications;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account = await SharedPreferencesHelper.getInfo();
      Account? account2 = await ApiAuthentication.refreshToken(
          account!.refreshToken, account.accessToken);
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/notifications?AccountId=$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );

      if (response2.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'];
        List<NotificationItem> notifications = results
            .map<NotificationItem>((item) => NotificationItem.fromJson(item))
            .toList();
        SharedPreferencesHelper.saveNotifications(notifications);
      }
    } else {
      return [];
    }

    return notifications;
  }

  static Future<void> updateStatusNotification(int id, String authToken) async {
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/notifications/$id/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      print("Successfully updated!");
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account = await SharedPreferencesHelper.getInfo();
      Account? account2 = await ApiAuthentication.refreshToken(
          account!.refreshToken, account.accessToken);
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/notifications/$id/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        print("Successfully updated!");
      }
    }
  }

  static Future<void> deleteAllNotifications(
      List<int> ids, String authToken) async {
    String jsonBody = jsonEncode(ids);
    final response = await http.delete(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/notifications'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      print("Delete all notifications successfully!");
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account = await SharedPreferencesHelper.getInfo();
      Account? account2 = await ApiAuthentication.refreshToken(
          account!.refreshToken, account.accessToken);
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.delete(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: ids,
      );
      if (response2.statusCode == 200) {
        print("Delete all notifications successfully!");
      }
    }
  }
}
