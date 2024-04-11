import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/notification_item.dart';

class ApiNotification {
  static Future<List<NotificationItem>> getNotifications() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    List<NotificationItem> notifications = [];
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/notifications?AccountId=${account!.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final results = jsonData['results'];
      if (results == null) return [];
      notifications = results
          .map<NotificationItem>((item) => NotificationItem.fromJson(item))
          .toList();
      return notifications;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/notifications?AccountId=${account2!.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'];
        if (results == null) return [];
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

  static Future<bool> updateStatusNotification(int id) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/notifications/$id/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      print("Successfully updated!");
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/notifications/$id/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        print("Successfully updated!");
        return true;
      } else {
        return false;
      }
    } else {
      print("Error");
      return false;
    }
  }

  static Future<bool> deleteAllNotifications(List<int> ids) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    String jsonBody = jsonEncode(ids);
    final response = await http.delete(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/notifications'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account!.accessToken}',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      print("Delete all notifications successfully!");
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.delete(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}}',
        },
        body: jsonBody,
      );
      if (response2.statusCode == 200) {
        print("Delete all notifications successfully!");
        return true;
      } else {
        return false;
      }
    } else {
      print("Error delete");
      return false;
    }
  }
}
