import 'package:ajay_flutter_web_task/app_provider.dart';
import 'package:ajay_flutter_web_task/overview.dart';
import 'package:ajay_flutter_web_task/theme.dart';
import 'package:ajay_flutter_web_task/widgets/graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
