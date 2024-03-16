import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/findanounymous_assets.dart';
import 'package:path_provider/path_provider.dart';

class AssetsAPI {
  static Future<String> saveImageToDevice(String imageUrl, String name) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDir.path}/image$name.png';
      final File imageFile = File(filePath);
      await imageFile.writeAsBytes(response.bodyBytes);
      return filePath;
    } catch (e) {
      return '';
    }
  }

  Future<FindAnonymousAsset> ConvertToFindAnonymousAssets(
      dynamic element) async {
    int id = int.parse(element['id']);
    List<String> des = element['value'].toString().split(';');
    String description = des[0];
    String imgLink = des[1];
    int numberOfDescription = description.split(',').length + 1;
    String imgPath = await saveImageToDevice(imgLink, element['id'].toString());
    FindAnonymousAsset result = FindAnonymousAsset(
        id: id,
        description: description,
        numberOfDescription: numberOfDescription,
        imgPath: imgPath);
    return result;
  }

  static Future<void> addAssets(int version, String authToken) async {
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/assets?PageSize=1000000&Version=$version'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final jsonList = jsonData['results'];
      List<FindAnonymousAsset> listAnomymous = [];
      List<String> listPathImageSource = [];
      for (var element in jsonList) {
        print(element.toString() + "ecec");
        switch (int.parse(element['gameId'].toString())) {
          case 1:
            String path = await saveImageToDevice(
                element['value'], element['id'].toString());
            print(path);
            listPathImageSource.add(path);
            break;
          case 2:
            String path = await saveImageToDevice(
                element['value'], element['id'].toString());
            print(path);
            listPathImageSource.add(path);
            break;
          case 4:
            break;
          case 5:
            break;
        }
      }
      await SharedPreferencesHelper.saveImageResoure(listPathImageSource);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account = await SharedPreferencesHelper.getInfo();
      Account? account2 = await ApiAuthentication.refreshToken(
          account!.refreshToken, account.accessToken);
      SharedPreferencesHelper.saveInfo(account2!);
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/assets?PageSize=1000000&Version=$version'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final jsonList = jsonData['results'];
        List<FindAnonymousAsset> listAnomymous = [];
        List<String> listPathImageSource = [];
        for (var element in jsonList) {
          switch (int.parse(element['gameId'])) {
            case 1:
              String path = await saveImageToDevice(
                  element['value'], element['id'].toString());
              print(path);
              listPathImageSource.add(path);
              break;
            case 2:
              String path = await saveImageToDevice(
                  element['value'], element['id'].toString());
              print(path);
              listPathImageSource.add(path);
              break;
            case 4:
              break;
            case 5:
              break;
          }
        }
        await SharedPreferencesHelper.saveImageResoure(listPathImageSource);
      } else {
        print(response2.body);
      }
    } else {
      print(response.body);
    }
  }
}
