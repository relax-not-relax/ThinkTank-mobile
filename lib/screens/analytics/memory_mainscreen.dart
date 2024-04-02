import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/analytics_api.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/models/analysis_type.dart';
import 'package:thinktank_mobile/screens/analytics/statistics_screen.dart';
import 'package:thinktank_mobile/widgets/analyst/pie_chart_memory.dart';
import 'package:thinktank_mobile/widgets/appbar/normal_appbar.dart';
import 'package:thinktank_mobile/widgets/analyst/game_statistic_item.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';

class MemoryMainScreen extends StatefulWidget {
  const MemoryMainScreen({super.key});

  @override
  State<MemoryMainScreen> createState() => _MemoryMainScreenState();
}

class _MemoryMainScreenState extends State<MemoryMainScreen> {
  bool isLoading = true;
  AnalysisType? tracking;
  late Future<void> _initMemoryType;

  Future<void> getMemoryType() async {
    tracking = await ApiAnalytics.getMemoryTypeTracking();
    if (mounted) {
      setState(() {
        tracking;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _initMemoryType = getMemoryType();
    _initMemoryType.then((value) {
      isLoading = false;
      print(tracking);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: TNormalAppbar(title: "Memory Tracking"),
      body: isLoading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CustomLoadingSpinner(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/pics/main_bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView(
                addAutomaticKeepAlives: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(14, 20, 14, 0),
                            child: Text(
                              "Statistics",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 50,
                              child: Text(
                                "Statistics on how your memory improves according to score and completion time of each mini games.",
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          if (index >= 0 && index <= 3) {
                            return Container(
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              child: GameStatisticItem(
                                game: games[index],
                                openStatistic: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return StatisticsScreen(
                                          game: games[index],
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(14, 20, 14, 0),
                            child: Text(
                              "Your memory trends",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 50,
                              child: Text(
                                "The chart analyzes practice trends according to your short-term memory patterns.",
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  tracking ==
                          const AnalysisType(
                            percentOfImagesMemory: 0,
                            percentOfAudioMemory: 0,
                            percentOfSequentialMemory: 0,
                          )
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/pics/track.png"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Let's start training now",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Text(
                                  "Start playing games so we can collect data about your memory trends.",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 185, 185, 185),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            PieChartMemory(
                              type: tracking!,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                ],
              ),
            ),
    );
  }
}
