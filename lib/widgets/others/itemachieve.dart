import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ItemAchieveAccount extends StatelessWidget {
  const ItemAchieveAccount({
    super.key,
    required this.imgLink,
    required this.backgroundColor,
    required this.shadowColor,
    required this.title,
    required this.description,
    required this.progress,
    required this.total,
    required this.received,
  });
  final String imgLink;
  final Color backgroundColor;
  final Color shadowColor;
  final String title;
  final String description;
  final int progress;
  final int total;
  final bool received;

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return Container(
      height: 150,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          ColorFiltered(
            colorFilter: (progress / total != 1)
                ? const ColorFilter.mode(
                    Color.fromARGB(172, 0, 0, 0),
                    BlendMode.hue,
                  )
                : const ColorFilter.mode(
                    Color.fromARGB(0, 255, 255, 255),
                    BlendMode.hue,
                  ),
            child: Container(
              height: 100,
              width: 80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Image.network(imgLink),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                (progress / total != 1)
                    ? Container(
                        margin: const EdgeInsets.only(top: 10, left: 10),
                        child: LinearPercentIndicator(
                          animation: true,
                          lineHeight: 25.0,
                          animationDuration: 1000,
                          animateFromLastPercent: true,
                          percent: (progress / total < 0)
                              ? 0
                              : ((progress / total > 1) ? 1 : progress / total),
                          barRadius: const Radius.circular(10.0),
                          progressColor: const Color.fromRGBO(255, 199, 0, 1),
                          backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
                          center: Text(
                            '$progress/$total',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )
                    : Visibility(
                        visible: true,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, top: 10),
                            height: 30,
                            width: 150,
                            decoration: BoxDecoration(
                              color: (!received)
                                  ? const Color.fromRGBO(255, 199, 0, 1)
                                  : Colors.grey,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                (!received)
                                    ? 'Receive reward'
                                    : 'Received reward',
                                style: TextStyle(
                                  color:
                                      (received) ? Colors.black : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
