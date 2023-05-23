import 'package:ajay_flutter_web_task/app_provider.dart';
import 'package:ajay_flutter_web_task/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'widgets/app_nav_bar.dart';

class WatchList extends StatelessWidget {
  const WatchList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      home: const WatchListHome(),
    );
  }
}

class WatchListHome extends StatelessWidget {
  const WatchListHome({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.read<AppProvider>();
    // appProvider.isMobile = MediaQuery.of(context).size.width <= 480;
    return Scaffold(
      bottomSheet: MediaQuery.of(context).size.width < 540
          ? const BottomNavBar()
          : const SizedBox(),
      backgroundColor:
          const Color.fromARGB(255, 245, 247, 255).withOpacity(0.9),
      body: (MediaQuery.of(context).size.width > 540)
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: const [
                  DesktopWatchlist(),
                  SizedBox(width: 20),
                  WatchlistStockColumn(),
                  SizedBox(width: 20),
                  Expanded(flex: 4, child: WatchlistOverview()),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: const [
                  SizedBox(height: 20),
                  WatchlistStockColumn(),
                  SizedBox(height: 20),
                  WatchlistOverview(isMobile: true),
                  SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}

class WatchlistStockColumn extends StatelessWidget {
  const WatchlistStockColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.read<AppProvider>();
    List<List<Points>> points = [
      for (int i = 0; i < 4; i++)
        appProvider.getChartData(
          isMiniGraph: true,
          random: appProvider.random,
        ),
    ];
    List<Graph> graph = [
      for (int i = 0; i < 4; i++) Graph(points: points[i]),
    ];
    return Container(
      width: 400,
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.boxShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // for (int i = 0; i < 4; i++)
            Consumer(
              builder: (context, AppProvider appProvider, child) => Column(
                children: [
                  for (int i in appProvider.indexList)
                    StockCard(
                      index: i,
                      graph: graph[i],
                      isDeclining:
                          points[i][points[i].length - 1].y > points[i][0].y,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List points;

  const LineChartWidget(this.points, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                barWidth: 3,
                spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
                isCurved: true,
                dotData: FlDotData(
                  show: false,
                ),
                color: Colors.green,
              ),
            ],
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            lineTouchData: LineTouchData(
                enabled: true,
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
                getTouchLineEnd: (_, __) => double.infinity),
          ),
        ));
  }
}

class StockCard extends StatelessWidget {
  const StockCard(
      {super.key,
      required this.index,
      required this.graph,
      required this.isDeclining});
  final int index;
  final Graph graph;
  final bool isDeclining;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.read<AppProvider>();
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
        if (appProvider.selectedStockIndex != index) {
          appProvider.selectedStockIndex = index;
          appProvider.notify();
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: appProvider.selectedStockIndex == index
              ? AppTheme.boxShadow
              : null,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: graph,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              appProvider.watchlistStocks[index],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(width: 20),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDeclining ? Colors.green : Colors.red,
                  ),
                  child: const Text(
                    "+13.00 (+0.12%)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "2126.33",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDeclining ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopWatchlist extends StatelessWidget {
  const DesktopWatchlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SideBar(),
        const SizedBox(
          width: 15,
        ),
        Consumer(
          builder: (context, AppProvider appProvider, child) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.boxShadow,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 4; i++)
                  InkWell(
                    onTap: () {
                      if (appProvider.activeWatchlist != i) {
                        appProvider.activeWatchlist = i;
                        appProvider.indexList.shuffle();
                        appProvider.notify();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: AppTheme.boxShadow,
                      ),
                      child: Text(
                        "Watchlist ${i + 1}",
                        style: TextStyle(
                          color: appProvider.activeWatchlist == i
                              ? Colors.blue
                              : Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WatchlistOverview extends StatelessWidget {
  const WatchlistOverview({super.key, this.isMobile = false});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    // AppProvider appProvider = context.read<AppProvider>();
    // List<Points> points = appProvider.getChartData(random: Random());
    return Consumer(
      builder: (context, AppProvider appProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 45),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${appProvider.watchlistStocks[appProvider.selectedStockIndex]} LTD",
                style: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                "${appProvider.watchlistStocks[appProvider.selectedStockIndex]} / NSE",
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 20),
          !isMobile
              ? const Expanded(
                  child: _GraphOverviewBottomDetails(),
                )
              : const _GraphOverviewBottomDetails(),
        ],
      ),
    );
  }
}

class _GraphOverviewBottomDetails extends StatelessWidget {
  const _GraphOverviewBottomDetails();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Graph(
            points: context.watch<AppProvider>().getChartData(random: Random()),
            isMiniGraph: false,
            barWidth: 3,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: AppTheme.boxShadow,
                    ),
                    // child: const Spacer(),
                  ),
                  const SizedBox(height: 20),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: AppTheme.boxShadow,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.14,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: AppTheme.boxShadow,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.14,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: AppTheme.boxShadow,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.14,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

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
