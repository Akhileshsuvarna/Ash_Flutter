import 'dart:io';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/models/exercise_meta.dart';
import 'package:health_connector/models/exercise_score.dart';
import 'package:health_connector/util/converter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import '../constants.dart';
import '../globals.dart';
import 'components/custom_back_button.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.exerciseScore, required this.meta})
      : super(key: key);

  final ExerciseScore exerciseScore;
  final ExerciseMeta meta;

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Size _size;

  var scr = GlobalKey();

  final List<int> showIndexes = const [1, 3, 5];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
      fontFamily: 'Digital',
      fontSize: 18,
    );
    String text = value.toInt().toString();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
      fontFamily: 'Digital',
      fontSize: 12,
    );
    String text = value == -1
        ? 'Bad'
        : value == 0
            ? 'NF'
            : 'Good';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  List<FlSpot> _getSpots() {
    List<FlSpot> spots = [];

    for (double i = 0; i < widget.exerciseScore.streakMap.length; i++) {
      if (i == 0 &&
          widget.exerciseScore.streakMap[i.toInt()].streakMeanTime > 0) {
        spots.add(const FlSpot(0, 0));
      } else {
        if (widget.exerciseScore.streakMap[i.toInt()].streakEndTime -
                widget.exerciseScore.streakMap[i.toInt()].streakStartTime >
            2) {
          spots.add(FlSpot(
              widget.exerciseScore.streakMap[i.toInt()].streakStartTime
                  .toDouble(),
              widget.exerciseScore.streakMap[i.toInt()].streakStatus
                  .toDouble()));
          spots.add(FlSpot(
              widget.exerciseScore.streakMap[i.toInt()].streakEndTime
                  .toDouble(),
              widget.exerciseScore.streakMap[i.toInt()].streakStatus
                  .toDouble()));
        }
      }
    }

    if (spots
        .firstWhere((element) => element.y == 0, orElse: () => FlSpot.nullSpot)
        .isNull()) {
      spots.add(FlSpot(spots.last.x, 0));
    }
    if (spots
        .firstWhere((element) => element.y == 1, orElse: () => FlSpot.nullSpot)
        .isNull()) {
      spots.add(FlSpot(spots.last.x, 1));
    }
    if (spots
        .firstWhere((element) => element.y == -1, orElse: () => FlSpot.nullSpot)
        .isNull()) {
      spots.add(FlSpot(spots.last.x, -1));
    }
    return spots;
  }

  @override
  void initState() {
    super.initState();
    _uploadTofirebase();
  }

  _uploadTofirebase() {
    try {
      Globals.uploadExerciseResult(widget.meta, widget.exerciseScore);
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        // showingIndicators: showIndexes,
        spots: _getSpots(),
        isCurved: true,
        curveSmoothness: 0.1,
        barWidth: 4,
        shadow: const Shadow(blurRadius: 8, color: Colors.black),
        belowBarData: BarAreaData(
          show: false,
          gradient: LinearGradient(
            colors: [
              const Color(0xff12c2e9).withOpacity(0.4),
              const Color(0xffc471ed).withOpacity(0.4),
              const Color(0xfff64f59).withOpacity(0.4),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        dotData: FlDotData(show: true),
        gradient: const LinearGradient(
          colors: [
            Color(0xff12c2e9),
            Color(0xffc471ed),
            Color(0xfff64f59),
          ],
          stops: [0.1, 0.4, 0.9],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      // // Simple Line from (0,0) to (lastpoint in chart,1)
      LineChartBarData(
        spots: [
          const FlSpot(0, 0),
          FlSpot(
              widget.exerciseScore.streakMap.last.streakEndTime.toDouble(), 0),
        ],
        isCurved: false,
        barWidth: 1,
        dotData: FlDotData(show: false),
        color: Colors.grey,
      ),
    ];
    final tooltipsOnBar = lineBarsData[0];
    _size = MediaQuery.of(context).size;
    return RepaintBoundary(
      key: scr,
      child: Scaffold(
        backgroundColor: Constants.appBackgroundColor,
        appBar: AppBar(
          title: Text(
            "Report",
            style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: customBackButton(context, color: Colors.black),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: _size.height / 6),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: _size.height / 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: _size.width / 64,
                        right: _size.width / 64,
                      ),
                      child: _progressChart(
                        lineBarsData: lineBarsData,
                        tooltipsOnBar: tooltipsOnBar,
                        // showIndexes: showIndexes,
                      ),
                    ),
                  ),
                  Text(
                    '${((widget.exerciseScore.framesWithRequiredPose / widget.exerciseScore.framesProcessed) * 100).floor()} %',
                    style: GoogleFonts.lexendDeca(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w100,
                        fontSize: 88,
                      ),
                    ),
                  ),
                  Text(
                    'accuracy',
                    style: GoogleFonts.lexendDeca(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: _size.height / 64),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: LinearPercentIndicator(
                      lineHeight: _size.height / 38,
                      percent: widget.exerciseScore.framesWithRequiredPose /
                          widget.exerciseScore.framesProcessed,
                      progressColor: Converter.hexToColor('4b39ef'),
                      backgroundColor: Converter.hexToColor('1e2429'),
                      barRadius: const Radius.circular(64),
                      animation: true,
                    ),
                  ),
                  SizedBox(height: _size.height / 64),
                  Padding(
                    padding: EdgeInsets.only(
                      left: _size.width / 16,
                      right: _size.width / 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Progress',
                              style: GoogleFonts.lexendDeca(
                                textStyle: TextStyle(
                                  color: Converter.hexToColor('8b97a2'),
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(height: _size.height / 80),
                            Text(
                              '100%',
                              style: GoogleFonts.lexendDeca(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Time',
                              style: GoogleFonts.lexendDeca(
                                textStyle: TextStyle(
                                  color: Converter.hexToColor('8b97a2'),
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(height: _size.height / 80),
                            Text(
                              '${widget.meta.exerciseDuration} min',
                              style: GoogleFonts.lexendDeca(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Status',
                              style: GoogleFonts.lexendDeca(
                                textStyle: TextStyle(
                                  color: Converter.hexToColor('8b97a2'),
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(height: _size.height / 80),
                            Text(
                              _getStatus(),
                              style: GoogleFonts.lexendDeca(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: _shareButton(),
      ),
    );
  }

  void _takeScreenShotAndShare() async {
    RenderRepaintBoundary boundary =
        scr.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData?.buffer.asUint8List();

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File(
            '${directory.path}/health${DateTime.now().millisecondsSinceEpoch}.png')
        .create();
    await imagePath.writeAsBytes(pngBytes!);

    /// Share Plugin
    await Share.shareFiles([imagePath.path]);
  }

  String _getStatus() {
    var percent = ((widget.exerciseScore.framesWithRequiredPose /
                widget.exerciseScore.framesProcessed) *
            100)
        .floor();
    if (percent > 95) {
      return 'Perfect';
    } else if (percent > 74) {
      return 'Good';
    } else if (percent > 49) {
      return 'Average';
    } else if (percent > 24) {
      return 'Normal';
    } else {
      return 'Poor';
    }
  }

  Widget _shareButton() => Container(
        height: _size.height / 6,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: _size.height / 8,
              color: Converter.hexToColor('7cc1df'),
            ),
            Positioned(
              child: Center(
                child: Column(
                  children: [
                    RawMaterialButton(
                      onPressed: _takeScreenShotAndShare,
                      elevation: 2.0,
                      fillColor: const Color.fromARGB(255, 126, 87, 194),
                      child: const Icon(
                        Icons.share,
                        size: 35.0,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                    ),
                    SizedBox(height: _size.height / 64),
                    Text(
                      'Share Results',
                      style: GoogleFonts.lexendDeca(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              top: 0,
            ),
          ],
        ),
      );

  Widget _progressChart(
          {required List<LineChartBarData> lineBarsData,
          required LineChartBarData tooltipsOnBar}) =>
      LineChart(
        LineChartData(
          // showingTooltipIndicators: showIndexes.map((index) {
          //   return ShowingTooltipIndicators([
          //     LineBarSpot(tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar),
          //         tooltipsOnBar.spots[index]),
          //   ]);
          // }).toList(),
          lineTouchData: LineTouchData(
            enabled: true,
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: Colors.pink,
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 8,
                      color: lerpGradient(
                        barData.gradient!.colors,
                        barData.gradient!.stops!,
                        percent / 100,
                      ),
                      strokeWidth: 2,
                      strokeColor: Colors.black,
                    ),
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.pink,
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                return lineBarsSpot.map((lineBarSpot) {
                  return LineTooltipItem(
                    lineBarSpot.y.toString(),
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: lineBarsData,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              // axisNameWidget: const Text('Pose match'),
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 44,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets,
                reservedSize: 32,
              ),
            ),
            rightTitles: AxisTitles(
              // axisNameWidget: const Text('count'),
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 0,
              ),
            ),
            topTitles: AxisTitles(
              axisNameWidget: const Text(''),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
        ),
      );
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s], rightStop = stops[s + 1];
    final leftColor = colors[s], rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
