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
            Container(
              width: MediaQuery.of(context).size.width,
              height: 180,
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 40,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(61, 129, 140, 155),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Type your message",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 102, 102, 102),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              borderSide: BorderSide(
                                color:
                                    Colors.transparent, // Màu viền khi có focus
                                width: 1,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 7.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(69, 189, 189, 189),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _handleSubmit,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
