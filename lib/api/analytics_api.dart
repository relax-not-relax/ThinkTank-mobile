import 'dart:convert';

import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/analysis.dart';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/models/analysis_type.dart';

class ApiAnalytics {
  static Future<List<Analysis>> getMemoryTracking(
      int gameId, int filterMonth, int filterYear) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/analyses?AccountId=${account!.id}&GameId=$gameId&FilterMonth=$filterMonth&FilterYear=$filterYear'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    List<Analysis> results = [];

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      for (var element in jsonData) {
        results.add(Analysis.fromJson(element));
      }
      return results;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();

      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/analyses?AccountId=${account2!.id}&GameId=$gameId&FilterMonth=$filterMonth&FilterYear=$filterYear'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        print(jsonData);
        for (var element in jsonData) {
          results.add(Analysis.fromJson(element));
        }
        return results;
      } else {
        return [];
      }
    } else {
      print("co loi");
      return [];
    }
  }

  static Future<AnalysisType> getMemoryTypeTracking() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/analyses/${account!.id}/by-memory-type'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${account.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      AnalysisType typeTracking = AnalysisType.fromJson(jsonData);
      return typeTracking;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/analyses/${account2.id}/by-memory-type'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response2.body);
        print(jsonData);
        AnalysisType typeTracking = AnalysisType.fromJson(jsonData);
        return typeTracking;
      } else {
        return const AnalysisType(
          percentOfImagesMemory: 0,
          percentOfAudioMemory: 0,
          percentOfSequentialMemory: 0,
        );
      }
    } else {
      return const AnalysisType(
        percentOfImagesMemory: 0,
        percentOfAudioMemory: 0,
        percentOfSequentialMemory: 0,
      );
    }
  }
}
