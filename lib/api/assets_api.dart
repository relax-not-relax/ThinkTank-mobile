import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/findanounymous_assets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thinktank_mobile/models/image_resource.dart';
import 'package:thinktank_mobile/models/musicpasssource.dart';

class AssetsAPI {
  static Future<String> saveImageToDevice(String imageUrl, String name) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDir.path}/image$name.png';
      final File imageFile = File(filePath);
      await imageFile.writeAsBytes(response.bodyBytes);
      print(filePath);
      return filePath;
    } catch (e) {
      return '';
    }
  }

  static Future<String> saveAudioToDevice(String audioUrl, String name) async {
    try {
      final response = await http.get(Uri.parse(audioUrl));
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDir.path}/audio$name.mp3';
      final File imageFile = File(filePath);
      await imageFile.writeAsBytes(response.bodyBytes);
      print(filePath);
      return filePath;
    } catch (e) {
      return '';
    }
  }

  static Future<FindAnonymousAsset> ConvertToFindAnonymousAssets(
      dynamic element) async {
    print(element['value'].toString() + "Lukaku");
    int id = int.parse(element['id'].toString());
    List<String> des = element['value'].toString().split(';');
    int topicId = int.parse(element['topicId'].toString());

    String description = des[0];
    String imgLink = des[1];
    int numberOfDescription = description.split(',').length + 1;
    String imgPath = await saveImageToDevice(imgLink, element['id'].toString());
    FindAnonymousAsset result = FindAnonymousAsset(
        id: id,
        description: description,
        numberOfDescription: numberOfDescription,
        imgPath: imgPath,
        topicId: topicId);
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
    print("Version" + version.toString());
    int maxVersion = await SharedPreferencesHelper.getResourceVersion();

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final jsonList = jsonData['results'];
      List<FindAnonymousAsset> listAnomymous = [];
      List<ImageResource> listPathImageSource = [];
      List<MusicPasswordSource> listMusicpassword = [];
      List<FindAnonymousAsset> listRemoveAnomymous = [];
      List<ImageResource> listRemovePathImageSource = [];
      List<MusicPasswordSource> listRemoveMusicpassword = [];
      for (var element in jsonList) {
        if (int.parse(element['version'].toString()) > maxVersion) {
          maxVersion = int.parse(element['version'].toString());
        }
        switch (int.parse(element['gameId'].toString())) {
          case 1:
            if (bool.parse(element['status'].toString())) {
              String path = await saveImageToDevice(
                  element['value'], element['id'].toString());
              print(path);
              int topicId = int.parse(element['topicId'].toString());
              listPathImageSource.add(ImageResource(
                  id: int.parse(element['id'].toString()),
                  topicId: topicId,
                  value: path));
            } else {
              listRemovePathImageSource.add(ImageResource(
                  id: int.parse(element['id'].toString()),
                  topicId: 0,
                  value: ''));
            }

            break;
          case 2:
            if (bool.parse(element['status'].toString())) {
              String path = await saveAudioToDevice(
                  element['value'], element['id'].toString());
              print(path);
              MusicPasswordSource musicPasswordSource = MusicPasswordSource(
                  soundLink: path,
                  answer: element['answer'].toString(),
                  topicId: int.parse(element['topicId'].toString()),
                  id: int.parse(element['id'].toString()));
              listMusicpassword.add(musicPasswordSource);
            } else {
              MusicPasswordSource musicPasswordSource = MusicPasswordSource(
                  soundLink: '',
                  answer: element['answer'].toString(),
                  topicId: int.parse(element['topicId'].toString()),
                  id: int.parse(element['id'].toString()));
              listRemoveMusicpassword.add(musicPasswordSource);
            }

            break;
          case 4:
            if (bool.parse(element['status'].toString())) {
              String path = await saveImageToDevice(
                  element['value'], element['id'].toString());
              int topicId = int.parse(element['topicId'].toString());
              listPathImageSource.add(ImageResource(
                  id: int.parse(element['id'].toString()),
                  topicId: topicId,
                  value: path));
            } else {
              listRemovePathImageSource.add(ImageResource(
                  id: int.parse(element['id'].toString()),
                  topicId: 0,
                  value: ''));
            }
            break;
          case 5:
            if (bool.parse(element['status'].toString())) {
              FindAnonymousAsset asset =
                  await ConvertToFindAnonymousAssets(element);
              listAnomymous.add(asset);
            } else {
              listRemoveAnomymous.add(FindAnonymousAsset(
                  id: int.parse(element['id'].toString()),
                  description: '',
                  numberOfDescription: 1,
                  imgPath: '',
                  topicId: 0));
            }
            break;
        }
      }
      await SharedPreferencesHelper.saveResourceVersion(maxVersion);
      await SharedPreferencesHelper.saveImageResoure(listPathImageSource);
      await SharedPreferencesHelper.saveAnonymousResoure(listAnomymous);
      await SharedPreferencesHelper.saveMusicPasswordSources(listMusicpassword);
      await SharedPreferencesHelper.removeImageResoure(
          listRemovePathImageSource);
      await SharedPreferencesHelper.removeAnonymousResoure(listRemoveAnomymous);
      await SharedPreferencesHelper.removeMusicPasswordSources(
          listRemoveMusicpassword);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Account? account2 = await ApiAuthentication.refreshToken();
      final response2 = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/assets?PageSize=1000000&Version=$version'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${account2!.accessToken}',
        },
      );
      if (response2.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final jsonList = jsonData['results'];
        List<FindAnonymousAsset> listAnomymous = [];
        List<ImageResource> listPathImageSource = [];
        List<MusicPasswordSource> listMusicpassword = [];
        List<FindAnonymousAsset> listRemoveAnomymous = [];
        List<ImageResource> listRemovePathImageSource = [];
        List<MusicPasswordSource> listRemoveMusicpassword = [];
        for (var element in jsonList) {
          if (int.parse(element['version'].toString()) > maxVersion) {
            maxVersion = int.parse(element['version'].toString());
          }
          switch (int.parse(element['gameId'].toString())) {
            case 1:
              if (bool.parse(element['status'].toString())) {
                String path = await saveImageToDevice(
                    element['value'], element['id'].toString());
                print(path);
                int topicId = int.parse(element['topicId'].toString());
                listPathImageSource.add(ImageResource(
                    id: int.parse(element['id'].toString()),
                    topicId: topicId,
                    value: path));
              } else {
                listRemovePathImageSource.add(ImageResource(
                    id: int.parse(element['id'].toString()),
                    topicId: 0,
                    value: ''));
              }

              break;
            case 2:
              if (bool.parse(element['status'].toString())) {
                String path = await saveAudioToDevice(
                    element['value'], element['id'].toString());
                print(path);
                MusicPasswordSource musicPasswordSource = MusicPasswordSource(
                    soundLink: path,
                    answer: element['answer'].toString(),
                    topicId: int.parse(element['topicId'].toString()),
                    id: int.parse(element['id'].toString()));
                listMusicpassword.add(musicPasswordSource);
              } else {
                MusicPasswordSource musicPasswordSource = MusicPasswordSource(
                    soundLink: '',
                    answer: element['answer'].toString(),
                    topicId: int.parse(element['topicId'].toString()),
                    id: int.parse(element['id'].toString()));
                listRemoveMusicpassword.add(musicPasswordSource);
              }

              break;
            case 4:
              if (bool.parse(element['status'].toString())) {
                String path = await saveImageToDevice(
                    element['value'], element['id'].toString());
                int topicId = int.parse(element['topicId'].toString());
                listPathImageSource.add(ImageResource(
                    id: int.parse(element['id'].toString()),
                    topicId: topicId,
                    value: path));
              } else {
                listRemovePathImageSource.add(ImageResource(
                    id: int.parse(element['id'].toString()),
                    topicId: 0,
                    value: ''));
              }
              break;
            case 5:
              if (bool.parse(element['status'].toString())) {
                FindAnonymousAsset asset =
                    await ConvertToFindAnonymousAssets(element);
                listAnomymous.add(asset);
              } else {
                listRemoveAnomymous.add(FindAnonymousAsset(
                    id: int.parse(element['id'].toString()),
                    description: '',
                    numberOfDescription: 1,
                    imgPath: '',
                    topicId: 0));
              }
              break;
          }
        }
        await SharedPreferencesHelper.saveResourceVersion(maxVersion);
        await SharedPreferencesHelper.saveImageResoure(listPathImageSource);
        await SharedPreferencesHelper.saveAnonymousResoure(listAnomymous);
        await SharedPreferencesHelper.saveMusicPasswordSources(
            listMusicpassword);
        await SharedPreferencesHelper.removeImageResoure(
            listRemovePathImageSource);
        await SharedPreferencesHelper.removeAnonymousResoure(
            listRemoveAnomymous);
        await SharedPreferencesHelper.removeMusicPasswordSources(
            listRemoveMusicpassword);
      } else {
        print(response2.body);
      }
    } else {
      print(response.body);
    }
  }
}
