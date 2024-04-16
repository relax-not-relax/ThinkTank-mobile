import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';

class TextWidget extends StatelessWidget {
  String text;

  String fontFamily;
  bool overrideSizeStroke;
  double fontSize;
  double strokeWidth;
  Color strokeColor;
  List<Shadow>? shadow;
  Color color;

  TextWidget(
    this.text, {
    required this.fontFamily,
    this.overrideSizeStroke = false,
    this.fontSize = 20,
    this.strokeWidth = 0, // stroke width default
    this.strokeColor = Colors.white,
    Key? key,
    this.shadow,
    this.color = Colors.black,
  }) : super(key: key) {
    if (this.shadow == null) this.shadow = [];

    // stroke to big right, let make automate little

    // this.overrideSizeStroke will disable automate .. so we can set our number
    if (this.strokeWidth != 0 && !this.overrideSizeStroke) {
      // this code will resize stroke so size will set 1/7 of font size, if stroke size is more than 1/7 font size
      // yeayy
      if (this.fontSize / 7 * 1 < this.strokeWidth)
        this.strokeWidth = this.fontSize / 7 * 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    // to make a stroke text we need stack between 2 text..
    // 1 for text & one for stroke effect
    return Stack(
      // redundant right?
      // same effect & lest code later.. :)
      children: List.generate(2, (index) {
        // let declare style for text .. :)
        // index == 0 for effect

        TextStyle textStyle = index == 0
            ? TextStyle(
                fontFamily: this.fontFamily,
                fontSize: this.fontSize,
                shadows: this.shadow,
                foreground: Paint()
                  ..color = this.strokeColor
                  ..strokeWidth = this.strokeWidth
                  ..strokeCap = StrokeCap.round
                  ..strokeJoin = StrokeJoin.round
                  ..style = PaintingStyle.stroke,
              )
            : TextStyle(
                fontFamily: this.fontFamily,
                fontSize: this.fontSize,
                color: this.color,
              );

        // let disable stroke effect if this.strokeWidth == 0
        return Offstage(
          offstage: this.strokeWidth == 0 &&
              index == 0, // put index == 0 so just disable effect only.. yeayy
          child: Text(
            this.text,
            style: textStyle,
          ),
        );
      }).toList(),
    );
  }
}
