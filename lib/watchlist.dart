import 'package:ajay_flutter_web_task/app_provider.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const DesktopWatchlist(),
            const SizedBox(width: 20),
            if (MediaQuery.of(context).size.width > 540) ...[
              const Expanded(flex: 2, child: WatchlistStockColumn()),
              const SizedBox(width: 20),
              const Expanded(
                  flex: 4,
                  child: SingleChildScrollView(child: WatchlistOverview())),
            ],
            if (MediaQuery.of(context).size.width < 540)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      SizedBox(height: 20),
                      WatchlistStockColumn(),
                      SizedBox(height: 20),
                      WatchlistOverview(),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            // Expanded(
            //   child: Column(
            //     children: [
            //       const Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 0),
            //         child: Align(
            //             alignment: Alignment.centerRight,
            //             child: Icon(Icons.notifications_active)),
            //       ),
            //       const Text(
            //         "Nifty 50",
            //         style: TextStyle(
            //           fontSize: 30,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       const SizedBox(height: 3),
            //       const Text(
            //         "25,355.80",
            //         style: TextStyle(
            //           color: Colors.green,
            //           fontSize: 30,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       const SizedBox(height: 1),
            //       RichText(
            //         text: const TextSpan(
            //           text: "+13.00(",
            //           children: [
            //             TextSpan(
            //                 text: "+0.12%",
            //                 style: TextStyle(color: Colors.green)),
            //             TextSpan(text: ")"),
            //           ],
            //           style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 18,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ),
            //       const Expanded(flex: 3, child: _Graph()),
            //     ],
            //   ),
            // ),
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
    return Container(
      height: MediaQuery.of(context).size.height - 24,
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 60),
              for (int i = 0; i < 4; i++) const StockCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Graph extends StatefulWidget {
  const _Graph();

  @override
  State<_Graph> createState() => _GraphState();
}

class _GraphState extends State<_Graph> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    AppProvider appProvider = context.read<AppProvider>();
    appProvider.tabController = TabController(
        length: appProvider.activeTimeFilterTitle.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.read<AppProvider>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: SizedBox(
            height: 100,
            child: DefaultTabController(
              length: appProvider.activeTimeFilterTitle.length,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: appProvider.tabController,
                children: [
                  for (int i = 0;
                      i < appProvider.activeTimeFilterTitle.length;
                      i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: LineChartWidget(
                        appProvider.getChartData(Random()),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        ValueListenableBuilder<int>(
          valueListenable: appProvider.activeTimeFilterIndex,
          builder: (_, newAppNavValue, __) => Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: TabBar(
              // indicator: const BoxDecoration(),
              unselectedLabelColor: Colors.black.withOpacity(0.5),
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.zero,
              labelColor: Colors.blue,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              controller: appProvider.tabController,
              onTap: (index) async {
                appProvider.activeTimeFilterIndex.value = index;
              },
              tabs: appProvider.activeTimeFilterTitle
                  .map(
                    (text) => Tab(
                      height: 23,
                      iconMargin: EdgeInsets.zero,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            text,
                            style: const TextStyle(fontSize: 16),
                          ),
                          // if (appProvider.activeTab.value ==
                          //     appProvider.activeTimeFilterTitle.indexOf(text))
                          //   Container(
                          //     color: Colors.blue,
                          //     height: 2,
                          //     width: 21,
                          //   )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
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
                  tooltipHorizontalAlignment: FLHorizontalAlignment.center,
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
  const StockCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6)),
            child: const SizedBox(height: 70),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            "AXISBANK",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Spacer(),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green,
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
              const Text(
                "2126.33",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DesktopWatchlist extends StatelessWidget {
  const DesktopWatchlist({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 540
        ? Row(
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
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0f101828),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color(0x19101828),
                        blurRadius: 8,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 4; i++)
                        InkWell(
                          onTap: () {
                            appProvider.activeWatchlist = i;
                            appProvider.notify();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 15,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0f101828),
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                                BoxShadow(
                                  color: Color(0x19101828),
                                  blurRadius: 5,
                                  offset: Offset(0, 1),
                                ),
                              ],
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
          )
        : const SizedBox();
  }
}

class WatchlistOverview extends StatelessWidget {
  const WatchlistOverview({super.key});

  @override
  Widget build(BuildContext context) {
    List<Points> points = context.read<AppProvider>().getChartData(Random());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopGraph(points: points),
        const SizedBox(height: 20),
        Row(
          children: [
            Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0f101828),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color(0x19101828),
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      ),
                    ],
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
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0f101828),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color(0x19101828),
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      ),
                    ],
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
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0f101828),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color(0x19101828),
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      ),
                    ],
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
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0f101828),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color(0x19101828),
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      ),
                    ],
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
    );
  }
}

class _TopGraph extends StatelessWidget {
  const _TopGraph({
    super.key,
    required this.points,
  });

  final List<Points> points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Text(
          "INFOSYS LTD",
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
        const Text(
          "INFY / NSE",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          height: 150,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  barWidth: 3,
                  spots:
                      points.map((point) => FlSpot(point.x, point.y)).toList(),
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
                    tooltipHorizontalAlignment: FLHorizontalAlignment.center,
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
          ),
        )
      ],
    );
  }
}
