import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/models/analysis_type.dart';
import 'package:thinktank_mobile/widgets/analyst/indicator.dart';

class PieChartMemory extends StatefulWidget {
  const PieChartMemory({
    super.key,
    required this.type,
  });

  final AnalysisType type;

  @override
  State<PieChartMemory> createState() => _PieChartMemoryState();
}

class _PieChartMemoryState extends State<PieChartMemory> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: Color.fromARGB(255, 85, 124, 176),
                text: 'Visual',
                textColor: Colors.white,
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Color.fromRGBO(255, 195, 0, 1),
                text: 'Auditory',
                textColor: Colors.white,
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Color.fromARGB(255, 240, 122, 63),
                text: 'Sequential',
                textColor: Colors.white,
                isSquare: true,
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 85, 124, 176),
            value: widget.type.percentOfImagesMemory,
            title: '${widget.type.percentOfImagesMemory.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color.fromRGBO(255, 195, 0, 1),
            value: widget.type.percentOfAudioMemory,
            title: '${widget.type.percentOfAudioMemory.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );

        case 2:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 240, 122, 63),
            value: widget.type.percentOfSequentialMemory,
            title:
                '${widget.type.percentOfSequentialMemory.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
