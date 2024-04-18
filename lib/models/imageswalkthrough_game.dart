import 'dart:math';

import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/models/imageswalkthrough.dart';

class ImagesWalkthroughGame {
  List<ImagesWalkthrough> gameData = [];

  int imgCount = 6;
  int c = 0;
  double time = 0.0;

  List<ImagesWalkthrough> getImageData(int imgCount, List<String> inputData) {
    List<String> selectedImages = [];
    List<ImagesWalkthrough> data = [];
    selectedImages = inputData.sublist(0, imgCount);
    var rng = Random();

    for (int i = 0; i < selectedImages.length; i++) {
      var bigImgPath = selectedImages[i];
      var imageList = [bigImgPath];

      var remainingImages = List<String>.from(selectedImages)
        ..remove(bigImgPath);

      if (i == 0) {
        while (imageList.length < 4) {
          var randomIndex = rng.nextInt(remainingImages.length);
          if (!imageList.contains(remainingImages[randomIndex])) {
            imageList.add(remainingImages.removeAt(randomIndex));
          }
        }
      } else {
        imageList.add(selectedImages[i - 1]);
        remainingImages.remove(selectedImages[i - 1]);

        while (imageList.length < 4) {
          var randomIndex = rng.nextInt(remainingImages.length);
          if (!imageList.contains(remainingImages[randomIndex])) {
            imageList.add(remainingImages.removeAt(randomIndex));
          }
          imageList.shuffle();
        }
      }

      print('Big :' + bigImgPath);
      print('List: ' + imageList.toList().toString());

      data.add(ImagesWalkthrough(bigImgPath, imageList));
    }
    return data;
  }

  Future<double> getTimeImagesWalkthrough(int level) async {
    if (level == 1) {
      imgCount = 6;
    }
    if (level >= 2 && level <= 5) {
      imgCount = 8;
    } else if (level >= 6 && level <= 10) {
      imgCount = 12;
    } else if (level >= 11 && level <= 20) {
      imgCount = 16;
    } else if (level >= 21 && level <= 30) {
      imgCount = 20;
    } else if (level >= 31 && level <= 40) {
      imgCount = 24;
    } else {
      imgCount = 28;
    }

    int c = (level % 10 <= 1) ? level ~/ 10 : ((level ~/ 10) + 1);
    if (level == 1)
      return (3.15 * imgCount);
    else {
      return (await getTimeImagesWalkthrough(level - 1) -
          (3.15 - 0.48) / pow(2, c) / 10 * imgCount);
    }
  }

  Future initGame(int level, int? contestId, int? topicId) async {
    if (contestId != null) {
      Contest contest = (await SharedPreferencesHelper.getContests())
          .firstWhere((element) => element.id == contestId);
      List<AssetOfContest> tmps =
          await SharedPreferencesHelper.getAllContestAssets();
      List<String> listTmp = [];
      for (var element
          in tmps.where((element) => element.contestId == contestId)) {
        listTmp.add(element.value);
      }
      listTmp.shuffle();
      print(listTmp.length);
      time = contest.playTime.toDouble();
      imgCount = listTmp.length;
      gameData = getImageData(imgCount, listTmp);
    } else if (topicId != null) {
      List<String> listTmp =
          await SharedPreferencesHelper.getImageResourceByTopicId(topicId);
      listTmp.shuffle();
      print(listTmp.length);
      time = 150;
      imgCount = 20;
      gameData = getImageData(imgCount, listTmp);
    } else {
      List<String> listTmp =
          await SharedPreferencesHelper.getImageResourceByTopicId(40);
      listTmp.shuffle();

      time = await getTimeImagesWalkthrough(level);

      if (level == 1) {
        imgCount = 6;

        gameData = getImageData(imgCount, listTmp);
      } else if (level >= 2) {
        if (level >= 2 && level <= 5) {
          imgCount = 8;
        } else if (level >= 6 && level <= 10) {
          imgCount = 12;
        } else if (level >= 11 && level <= 20) {
          imgCount = 16;
        } else if (level >= 21 && level <= 30) {
          imgCount = 20;
        } else if (level >= 31 && level <= 40) {
          imgCount = 24;
        } else {
          imgCount = 28;
        }

        gameData = getImageData(imgCount, listTmp);
      }
    }
  }
}
