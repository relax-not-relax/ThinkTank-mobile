import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/api/analytics_api.dart';
import 'package:thinktank_mobile/models/analysis.dart';
import 'package:thinktank_mobile/models/analysis_group.dart';
import 'package:thinktank_mobile/models/analysis_group_average.dart';
import 'package:thinktank_mobile/models/game.dart';
import 'package:thinktank_mobile/screens/analytics/line_chart_memory.dart';
import 'package:thinktank_mobile/widgets/appbar/normal_appbar.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({
    super.key,
    required this.game,
  });

  final Game game;

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool isLoading = true;
  List<Analysis> memoryAnalysis = [];
  List<Analysis> results = [];
  Map<DateTime, List<Analysis>> groupedAnalyses = {};
  bool showByWeek = false;
  AnalysisGroupAverage? grouped;
  int currentLevel = 0;
  int count = 0;
  Widget? description;

  late Future<void> _initMemories;

  late int selectedMonth;
  late int selectedYear;

  List<Color> gradientColors = [
    const Color.fromRGBO(80, 228, 255, 1),
    const Color.fromRGBO(33, 150, 243, 1),
  ];

  void setCount(AnalysisGroupAverage data) {
    for (AnalysisGroup group
        in data.analysisAverageScoreByGroupLevelResponses) {
      if (group.averageOfPlayer > group.averageOfGroup) {
        count += 1;
      }
    }
    setState(() {
      count;
    });

    print(count);

    if (count >= 0 && count <= 2) {
      setState(() {
        description = SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            "Based on the chart, it seems like you haven't improved your short-term memory very much. Try and spend a little time practicing every day, overcoming more difficult challenges every day!",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      });
    } else if (count >=
        (data.analysisAverageScoreByGroupLevelResponses.length / 2).ceil()) {
      setState(() {
        description = SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            "You have a pretty good short-term memory. You've beaten a lot of your opponents and are above the game average in our system. It seems like you've spent a lot of time practicing, keep up the good work!",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      });
    } else if (count > 2 &&
        count <
            (data.analysisAverageScoreByGroupLevelResponses.length / 2)
                .ceil()) {
      setState(() {
        description = SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            "Based on the chart, we see your daily efforts. Practice your short-term memory more and surpass your limits!",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      });
    }
  }

  Future<void> getMemories(int month, int year) async {
    memoryAnalysis = await ApiAnalytics.getMemoryTracking(
      widget.game.id,
      month,
      year,
    );
    grouped = await ApiAnalytics.getAnalysisGroupAverage(widget.game.id);
    if (mounted) {
      setState(() {
        memoryAnalysis;
        grouped;
        groupedAnalyses = {};
        results.clear();
        for (var analysis in memoryAnalysis) {
          if (!groupedAnalyses.containsKey(analysis.endTime)) {
            groupedAnalyses[analysis.endTime] = [];
          }
          groupedAnalyses[analysis.endTime]!.add(analysis);
        }

        groupedAnalyses.forEach((endTime, analyses) {
          double sum =
              analyses.fold(0, (prev, element) => prev + element.value);
          double averageValue = sum / analyses.length;

          results.add(Analysis(endTime: endTime, value: averageValue));
        });
        print(results.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.game.id);

    selectedMonth = DateTime.now().month;
    selectedYear = DateTime.now().year;

    _initMemories = getMemories(selectedMonth, selectedYear);
    _initMemories.then((value) {
      setState(() {
        isLoading = false;
        currentLevel = grouped!.currentLevel;
        setCount(grouped!);
        print(memoryAnalysis);
        print(grouped);
      });
    });
  }

  Future turnOn() async {
    setState(() {
      isLoading = true;
    });
  }

  Future turnOff() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    Future displayBottomSheet(BuildContext context) {
      return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 220,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        DropdownButton<int>(
                          value: selectedMonth,
                          hint: Text("Select month"),
                          items: <String>[
                            'January',
                            'February',
                            'March',
                            'April',
                            'May',
                            'June',
                            'July',
                            'August',
                            'September',
                            'October',
                            'November',
                            'December'
                          ].asMap().entries.map((entry) {
                            int idx = entry.key;
                            String month = entry.value;
                            return DropdownMenuItem<int>(
                              value: idx + 1,
                              child: Text(month),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              // Gọi setState trong StatefulBuilder
                              selectedMonth = newValue!;
                            });
                          },
                          dropdownColor: Colors.white,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        DropdownButton<int>(
                          value: selectedYear,
                          hint: Text("Chọn năm"),
                          items: List<DropdownMenuItem<int>>.generate(7,
                              (int index) {
                            return DropdownMenuItem<int>(
                              value: 2024 + index,
                              child: Text("Year ${2024 + index}"),
                            );
                          }),
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedYear = newValue!;
                            });
                          },
                          dropdownColor: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedMonth != null && selectedYear != null) {
                          Navigator.pop(context);

                          await turnOn();

                          await getMemories(selectedMonth, selectedYear);

                          await turnOff();

                          //print("$selectedMonth + " "$selectedYear");
                        } else {
                          print("Vui lòng chọn tháng và năm");
                        }
                      },
                      style: buttonPrimaryVer2(context),
                      child: Text(
                        "Confirm",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(103, 129, 140, 155),
                width: 1.0,
              ),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            toolbarHeight: 90.0,
            title: Text(
              "Statistics",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  displayBottomSheet(context);
                },
                icon: const Icon(
                  IconlyBold.filter,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Memory chart by piece of information and completion time",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        10,
                        20,
                        0,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "This chart will retrieve players' gaming data by day (Data value is calculated by dividing the information piece of that level by the player's time to complete the level).",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    memoryAnalysis.isEmpty
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
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Text(
                                    "You have no memory training data in this game this month.",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 185, 185, 185),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 1.20,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 18,
                                    left: 12,
                                    top: 70,
                                    bottom: 12,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            "Value",
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            right: showByWeek ? 30 : 20,
                                          ),
                                          width: showByWeek ? 900 : 1500,
                                          child: LineChart(
                                            showByWeek
                                                ? weekData()
                                                : mainData(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      showByWeek = !showByWeek;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                      showByWeek
                                          ? const Color.fromARGB(
                                              255, 175, 175, 175)
                                          : Color.fromARGB(52, 70, 70, 70),
                                    ),
                                  ),
                                  child: Text(
                                    'Weekly chart',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: showByWeek
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Memory chart by memory improvement process through each game",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        10,
                        20,
                        0,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "This chart will take the player's data after completing a cluster of levels and compare it with the average value of other players in that cluster of levels, to see if the player's short-term memory is really improved (Data value is calculated by dividing the information piece of that level by the player's time to complete the level).",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              "Value",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Container(
                            width: 900,
                            height: 450,
                            margin: const EdgeInsets.only(
                              right: 30,
                            ),
                            child: LineChartMemory(
                              data: grouped!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                          ),
                          height: 7,
                          width: 100,
                          color: const Color.fromRGBO(59, 255, 73, 1),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Average stats of all players",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                          ),
                          height: 7,
                          width: 100,
                          color: const Color.fromRGBO(255, 58, 242, 1),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Your average stats",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 34, 34, 34),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Your current level",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                currentLevel != 0 ? "$currentLevel" : "0",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          description!,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text = const Text('', style: style);

    if (value.toInt() % 2 == 0) {
      text = Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(
            '${(value.toInt() ~/ 2) + 1}/$selectedMonth',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget bottomTitleByWeekWidgets(double value, TitleMeta meta) {
    var style = GoogleFonts.inter(
      color: Colors.white,
      fontWeight: FontWeight.w400,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('Week 1', style: style);
        break;
      case 2:
        text = Text('Week 2', style: style);
        break;
      case 4:
        text = Text('Week 3', style: style);
        break;
      case 6:
        text = Text('Week 4', style: style);
        break;
      case 8:
        text = Text('Week 5', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;

      default:
        return Container();
    }

    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.left,
    );
  }

  LineChartData mainData() {
    final int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    List<FlSpot> spots = List.generate(daysInMonth, (index) {
      double yValue = 0;
      DateTime currentDate = DateTime(selectedYear, selectedMonth, index + 1);

      for (var analysis in results) {
        if (analysis.endTime.day == currentDate.day) {
          yValue = double.parse(analysis.value.toStringAsFixed(2));
          break;
        }
      }
      // Điều chỉnh giá trị x: nếu index > 0 thì x = index * 2, ngược lại x = index (để giữ nguyên giá trị 0)
      final double xValue = index > 0 ? index * 2.0 : index.toDouble();

      return FlSpot(xValue, yValue);
    });

    final double maxXValue = (daysInMonth - 1) * 2.0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color.fromRGBO(255, 255, 255, 0.102),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromRGBO(255, 255, 255, 0.102),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: maxXValue,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: false,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData weekData() {
    List<DateTime> getDaysInMonth(int month, int year) {
      List<DateTime> days = [];

      DateTime firstDayOfMonth = DateTime(year, month, 1);

      days.add(firstDayOfMonth);

      int totalDays = DateTime(year, month + 1, 0).day;

      for (int i = 2; i <= totalDays; i++) {
        days.add(DateTime(year, month, i));
      }

      return days;
    }

    List<Map<int, List<DateTime>>> groupDaysByWeek(List<DateTime> days) {
      Map<int, List<DateTime>> weekMap = {};
      List<Map<int, List<DateTime>>> weeksList = [];

      int firstDayWeekIndex =
          ((days.first.day - days.first.weekday + 10) / 7).floor();

      for (DateTime day in days) {
        int weekOfYear = ((day.day - day.weekday + 10) / 7).floor();

        int weekIndex = weekOfYear - firstDayWeekIndex + 1;
        if (weekMap.containsKey(weekIndex)) {
          weekMap[weekIndex]!.add(day);
        } else {
          weekMap[weekIndex] = [day];
        }
      }

      weekMap.forEach((key, value) {
        weeksList.add({key: value});
      });

      return weeksList;
    }

    List<DateTime> daysInMonth = getDaysInMonth(selectedMonth, selectedYear);
    List<Map<int, List<DateTime>>> weeksInMonth = groupDaysByWeek(daysInMonth);

    List<FlSpot> createFlSpotsFromData(
        List<Map<int, List<DateTime>>> weeksInMonth, List<Analysis> data) {
      List<FlSpot> spots = [];

      for (var weekEntry in weeksInMonth) {
        int weekNumber = weekEntry.keys.first;
        List<DateTime> weekDays = weekEntry.values.first;

        double sumValue = 0;
        int count = 0;

        for (DateTime day in weekDays) {
          for (Analysis analysis in data) {
            if (analysis.endTime.year == day.year &&
                analysis.endTime.month == day.month &&
                analysis.endTime.day == day.day) {
              sumValue += analysis.value;
              count++;
            }
          }
        }

        double yValue =
            count > 0 ? double.parse((sumValue / count).toStringAsFixed(2)) : 0;

        spots.add(FlSpot((weekNumber - 1) * 2.0, yValue));
      }

      return spots;
    }

    List<FlSpot> flSpots = createFlSpotsFromData(weeksInMonth, results);

    print(weeksInMonth);
    print(flSpots);

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: true),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: bottomTitleByWeekWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 8,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: flSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
