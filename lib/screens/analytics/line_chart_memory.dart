import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/models/analysis_group.dart';
import 'package:thinktank_mobile/models/analysis_group_average.dart';

class _LineChart extends StatelessWidget {
  const _LineChart({
    required this.group,
  });

  final List<AnalysisGroup> group;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 {
    final int data = group.length;
    print(data);
    final double maxXValue = (data - 1) * 3.0;
    return LineChartData(
      lineTouchData: lineTouchData1,
      titlesData: titlesData1,
      borderData: borderData,
      lineBarsData: lineBarsData1,
      minX: 0,
      maxX: maxXValue,
      maxY: 2,
      minY: 0,
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  LineTouchData get lineTouchData2 => const LineTouchData(
        enabled: false,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.white,
    );
    String text;
    switch (value.toDouble()) {
      case 0:
        text = '0';
        break;
      case 0.5:
        text = '0.5';
        break;
      case 1:
        text = '1';
        break;
      case 1.5:
        text = '1.5';
        break;
      case 2:
        text = '2';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 0.5,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('1', style: style);
        break;
      case 3:
        text = const Text('2 - 5', style: style);
        break;
      case 6:
        text = const Text('6 - 10', style: style);
        break;
      case 9:
        text = const Text('11 - 20', style: style);
        break;
      case 12:
        text = const Text('21 - 30', style: style);
        break;
      case 15:
        text = const Text('31 - 40', style: style);
        break;
      case 18:
        text = const Text('From 41', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
              color: const Color.fromRGBO(80, 228, 255, 1).withOpacity(0.2),
              width: 4),
          left: BorderSide(
              color: const Color.fromRGBO(80, 228, 255, 1).withOpacity(0.2),
              width: 4),
          right: BorderSide(
              color: const Color.fromRGBO(80, 228, 255, 1).withOpacity(0.2),
              width: 4),
          top: BorderSide(
              color: const Color.fromRGBO(80, 228, 255, 1).withOpacity(0.2),
              width: 4),
        ),
      );

  LineChartBarData get lineChartBarData1_1 {
    final int data = group.length;
    List<FlSpot> spots = List.generate(data, (index) {
      final double xValue = index > 0 ? index * 3.0 : index.toDouble();
      double yValue =
          double.parse(group[index].averageOfGroup.toStringAsFixed(2));
      return FlSpot(xValue, yValue);
    });

    print(spots);

    return LineChartBarData(
      isCurved: false,
      color: const Color.fromRGBO(59, 255, 73, 1),
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }

  LineChartBarData get lineChartBarData1_2 {
    final int data = group.length;
    List<FlSpot> spots = List.generate(data, (index) {
      final double xValue = index > 0 ? index * 3.0 : index.toDouble();
      double yValue =
          double.parse(group[index].averageOfPlayer.toStringAsFixed(2));
      return FlSpot(xValue, yValue);
    });

    return LineChartBarData(
      isCurved: false,
      color: const Color.fromRGBO(255, 58, 242, 1),
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: false,
        color: const Color.fromRGBO(255, 58, 242, 1).withOpacity(0),
      ),
      spots: spots,
    );
  }
}

class LineChartMemory extends StatefulWidget {
  const LineChartMemory({
    super.key,
    required this.data,
  });

  final AnalysisGroupAverage data;

  @override
  State<StatefulWidget> createState() => LineChartMemoryState();
}

class LineChartMemoryState extends State<LineChartMemory> {
  late bool isShowingMainData;
  List<AnalysisGroup> levelGroup = [];

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    levelGroup = widget.data.analysisAverageScoreByGroupLevelResponses;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Container(
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, left: 6),
                    child: Material(
                      color: Colors.transparent,
                      child: _LineChart(
                        group: levelGroup,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "Cluster level",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
