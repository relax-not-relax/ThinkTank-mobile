import 'package:flutter/material.dart';
import 'package:thinktank_mobile/data/imageswalkthrough_data.dart';

import 'package:thinktank_mobile/widgets/game/walkthrough_item.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class ImagesWalkthroughGameScreen extends StatefulWidget {
  const ImagesWalkthroughGameScreen({
    super.key,
    required this.onSelectImage,
    required this.onCorrectAnswer,
  });

  final void Function(String imgAnswer) onSelectImage;
  final void Function() onCorrectAnswer;

  @override
  State<ImagesWalkthroughGameScreen> createState() =>
      _ImagesWalkthroughGameScreenState();
}

class _ImagesWalkthroughGameScreenState
    extends State<ImagesWalkthroughGameScreen> {
  var currentQuestionIndex = 1;
  List<String>? shuffle;
  Widget? content;

  void answerQuestion(String selectedAnswer) {
    if (selectedAnswer == walkthroughs[currentQuestionIndex - 1].bigImgPath) {
      widget.onCorrectAnswer();
    }

    widget.onSelectImage(selectedAnswer);
    setState(() {
      currentQuestionIndex++;
      print(currentQuestionIndex);
      shuffle = List.from(walkthroughs[currentQuestionIndex].answerImgPath);
      shuffle!.shuffle();
    });
  }

  @override
  void initState() {
    super.initState();
    shuffle = List.from(walkthroughs[currentQuestionIndex].answerImgPath);
    shuffle!.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    double itemHeight = 170;
    double itemWidth = MediaQuery.of(context).size.width / 2;
    int itemCount = walkthroughs[0].answerImgPath.length;

    double gridViewHeight = (itemCount / 2).ceil() * (itemHeight + 8);

    content = (currentQuestionIndex == walkthroughs.length)
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 320,
                  width: 320,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/pics/walkthrough_win.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    bottom: 30.0,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 76,
                      width: 336,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 132, 53, 13),
                              blurRadius: 0,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: button1v1,
                          child: const Text(
                            'CONTINUE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'ButtonCustomFont',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          walkthroughs[currentQuestionIndex].bigImgPath),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                  ),
                  height: gridViewHeight,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: itemWidth / itemHeight,
                    ),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      return WalkThroughItem(
                        imgPath: shuffle![index],
                        onSelect: () {
                          answerQuestion(shuffle![index]);
                        },
                        itemIndex: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          );

    return content ?? SizedBox.shrink();
  }
}
