import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Graph extends StatelessWidget {
  const Graph({
    Key? key,
    required this.points,
    this.barWidth = 1,
    this.isMiniGraph = true,
  }) : super(key: key);

  final List points;
  final double barWidth;
  final bool isMiniGraph;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      height: 350,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              barWidth: barWidth,
              belowBarData: BarAreaData(
                show: true,
                // color: Colors.green,
                gradient: isMiniGraph
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: (points[points.length - 1].y < points[0].y)
                            ? [
                                Colors.red.shade400,
                                const Color.fromARGB(255, 245, 247, 255)
                                    .withOpacity(0.9),
                              ]
                            : [
                                Colors.green.shade400,
                                const Color.fromARGB(255, 245, 247, 255)
                                    .withOpacity(0.9),
                              ],
                      )
                    : const LinearGradient(colors: [
                        Colors.transparent,
                        Colors.transparent,
                      ]),
              ),
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: true,
              dotData: FlDotData(show: !isMiniGraph),
              color: !isMiniGraph
                  ? Colors.purple.shade400
                  : (points[points.length - 1].y > points[0].y)
                      ? Colors.green
                      : Colors.red,
            ),
            if (!isMiniGraph)
              LineChartBarData(
                barWidth: barWidth,
                isStepLineChart: true,
                belowBarData: BarAreaData(
                  show: true,
                  spotsLine: BarAreaSpotsLine(
                    show: true,
                    flLineStyle: FlLine(color: Colors.purple.shade400),
                  ),
                  // color: Colors.green,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:
                        // (points[points.length - 1].y < points[0].y)
                        //     ? [
                        //         Colors.red.shade400,
                        //         const Color.fromARGB(255, 245, 247, 255)
                        //             .withOpacity(0.9),
                        //       ]
                        //     :
                        [
                      Colors.purple.shade400,
                      const Color.fromARGB(255, 245, 247, 255).withOpacity(0.9),
                    ],
                  ),
                ),
                spots: points
                    .map((point) => FlSpot(point.x, point.y - 5))
                    .toList(),
                isCurved: true,
                dotData: FlDotData(show: false),
                color: Colors.purple.shade400,
              ),
          ],
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: false),
          lineTouchData: LineTouchData(
              enabled: false,
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.black,
                // tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                tooltipRoundedRadius: 200.0,
                fitInsideHorizontally: true,
                tooltipPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                fitInsideVertically: true,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map(
                    (LineBarSpot touchedSpot) {
                      const textStyle = TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      );
                      return LineTooltipItem(
                        "\$ ${points[touchedSpot.spotIndex].y.toStringAsFixed(2)}\n 12 Aug, 2023",
                        textStyle,
                      );
                    },
                  ).toList();
                },
              ),

              // on commenting the [getTouchedSpotIndicator] the exception -> Exception: indicatorsData and touchedSpotOffsets size should be same will go away - I've raised an issue in github
              getTouchedSpotIndicator: (barData, spotIndexes) {
                return [
                  if (!isMiniGraph)
                    TouchedSpotIndicatorData(
                      FlLine(color: Colors.transparent),
                      FlDotData(
                        getDotPainter: (p0, p1, p2, p3) {
                          return FlDotCirclePainter(
                            radius: 6.5,
                            color: Colors.blue.shade500,
                          );
                        },
                      ),
                    ),
                ];
              },
              getTouchLineEnd: (_, __) => double.infinity),
        ),
      ),
    );
  }
}
