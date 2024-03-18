import 'dart:math';

import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
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
          imageList.add(remainingImages.removeAt(randomIndex));
        }
      } else {
        imageList.add(selectedImages[i - 1]);
        remainingImages.remove(selectedImages[i - 1]);

        while (imageList.length < 4) {
          var randomIndex = rng.nextInt(remainingImages.length);
          imageList.add(remainingImages.removeAt(randomIndex));
          imageList.shuffle();
        }
      }

      data.add(ImagesWalkthrough(bigImgPath, imageList));
    }
    return data;
  }

  Future initGame(int level) async {
    List<String> listTmp = await SharedPreferencesHelper.getImageResource();
    listTmp.shuffle();

    if (level == 1) {
      imgCount = 6;
      time = 3.15 * imgCount;
      await SharedPreferencesHelper.saveImagesWalkthroughTime(time);

      gameData = getImageData(imgCount, listTmp);
    } else if (level >= 2) {
      time = await SharedPreferencesHelper.getImagesWalkthroughTime();

      c = level % 10 <= 1 ? (level ~/ 10) : (level ~/ 10 + 1);
      double levelConst = (3.15 - 0.48) / pow(2, c) / 10;
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

      double levelVar = time - levelConst;
      time = imgCount * levelVar;
      await SharedPreferencesHelper.saveImagesWalkthroughTime(time);

      gameData = getImageData(imgCount, listTmp);
    }
  }
}
