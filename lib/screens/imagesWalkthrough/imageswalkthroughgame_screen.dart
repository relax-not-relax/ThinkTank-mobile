import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:thinktank_mobile/data/imageswalkthrough_data.dart';
import 'package:thinktank_mobile/models/imageswalkthrough.dart';
import 'package:thinktank_mobile/widgets/game/walkthrough_item.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class ImagesWalkthroughGameScreen extends StatefulWidget {
  const ImagesWalkthroughGameScreen({
    super.key,
    required this.onSelectImage,
    required this.onCorrectAnswer,
    required this.onEndGame,
    required this.onInCorrectAnswer,
    required this.source,
    required this.onEndTime,
    required this.isEnd,
    required this.onDone,
  });

  final void Function(String imgAnswer) onSelectImage;
  final void Function() onCorrectAnswer;
  final void Function() onInCorrectAnswer;
  final void Function() onEndGame;
  final void Function() onDone;
  final List<ImagesWalkthrough> source;
  final void Function() onEndTime;
  final bool isEnd;

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
    if (widget.isEnd == false) {
      if (selectedAnswer ==
          widget.source[currentQuestionIndex - 1].bigImgPath) {
        widget.onCorrectAnswer();
      } else if (selectedAnswer !=
          widget.source[currentQuestionIndex - 1].bigImgPath) {
        widget.onInCorrectAnswer();
        setState(() {
          currentQuestionIndex = 1;
        });
      }

      widget.onSelectImage(selectedAnswer);
      setState(() {
        currentQuestionIndex++;
      });

      if (currentQuestionIndex == widget.source.length) {
        widget.onEndGame();
      } else {
        shuffle = List.from(widget.source[currentQuestionIndex].answerImgPath);
        shuffle!.shuffle();
      }
    } else {
      //widget.onEndTime();
    }
  }

  @override
  void initState() {
    super.initState();
    shuffle = List.from(widget.source[currentQuestionIndex].answerImgPath);
    shuffle!.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    double itemHeight = 170;
    double itemWidth = MediaQuery.of(context).size.width / 2;
    int itemCount = widget.source[0].answerImgPath.length;
    print(itemCount);

    double gridViewHeight = (itemCount / 2).ceil() * (itemHeight + 8);

    content = (currentQuestionIndex == widget.source.length)
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
                          onPressed: () {
                            widget.onDone();
                          },
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
        : Container(
            height: MediaQuery.of(context).size.height * 0.74,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        // image: AssetImage(
                        //     widget.source[currentQuestionIndex].bigImgPath),
                        image: FileImage(File(
                            widget.source[currentQuestionIndex].bigImgPath)),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
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
                          isBattle: false,
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
            ),
          );

    return content ?? SizedBox.shrink();
  }
}
