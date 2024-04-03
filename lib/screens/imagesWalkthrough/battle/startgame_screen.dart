import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thinktank_mobile/models/imageswalkthrough.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class StartBattleGameScreen extends StatefulWidget {
  const StartBattleGameScreen({
    super.key,
    //required this.source,
  });

  @override
  State<StartBattleGameScreen> createState() => _StartBattleGameScreenState();
}

class _StartBattleGameScreenState extends State<StartBattleGameScreen> {
  //final List<ImagesWalkthrough> source;

  final TextEditingController _controller = TextEditingController();

  void _handleSubmit() {
    print('Submitted: ${_controller.text}');

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    // return source.isNotEmpty
    //     ? Center(
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Container(
    //               height: 300,
    //               width: 300,
    //               decoration: BoxDecoration(
    //                 image: DecorationImage(
    //                   image: FileImage(File(source[0].bigImgPath)),
    //                   fit: BoxFit.cover,
    //                 ),
    //                 borderRadius: const BorderRadius.all(
    //                   Radius.circular(20.0),
    //                 ),
    //               ),
    //             ),
    //             //
    //             Container(
    //               height: MediaQuery.of(context).size.height * 0.2,
    //               width: MediaQuery.of(context).size.width,
    //               padding: const EdgeInsets.only(
    //                 bottom: 30.0,
    //               ),
    //               child: Align(
    //                 alignment: Alignment.bottomCenter,
    //                 child: SizedBox(
    //                   height: 76,
    //                   width: 300,
    //                   child: Container(
    //                     decoration: const BoxDecoration(
    //                       borderRadius: BorderRadius.all(
    //                         Radius.circular(100),
    //                       ),
    //                       boxShadow: [
    //                         BoxShadow(
    //                           color: Color.fromARGB(255, 132, 53, 13),
    //                           blurRadius: 0,
    //                           offset: Offset(0, 8),
    //                         ),
    //                       ],
    //                     ),
    //                     child: ElevatedButton(
    //                       onPressed: () {},
    //                       style: button1v1,
    //                       child: const Text(
    //                         'CONTINUE',
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 30,
    //                           fontWeight: FontWeight.w900,
    //                           fontFamily: 'ButtonCustomFont',
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       )
    //     : Center(
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Container(
    //               height: 300,
    //               width: 300,
    //               decoration: const BoxDecoration(
    //                 image: DecorationImage(
    //                   image: AssetImage("assets/pics/logo_2.png"),
    //                   fit: BoxFit.cover,
    //                 ),
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(20.0),
    //                 ),
    //               ),
    //             ),
    //             //
    //           ],
    //         ),
    //       );

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/pics/fruit_1.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
            ),
            //
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
                  width: 300,
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
      ),
    );
  }
}
