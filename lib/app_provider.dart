import 'package:flutter/material.dart';
import 'dart:math';

class AppProvider extends ChangeNotifier {
  bool isMobile = false;
  int activeWatchlist = 0;
  List indexList = [1, 2, 3, 0];
  List<String> watchlistStocks = ["INFY", "TATAMOTORS", "SBIN", "RELIANCE"];
  Random random = Random();
  List<String> activeTimeFilterTitle = ["Day", "Week", "Month", "Year", "All"];
  ValueNotifier<int> activeTimeFilterIndex = ValueNotifier<int>(0);
  TabController? tabController;
  ValueNotifier<int> activeTab = ValueNotifier<int>(0);
  List<String> tabTitle = [
    "Watchlist",
    "Portfolio",
    "Home",
    "Wallet",
    "Profile"
  ];
  int selectedStockIndex = 0;
  List<IconData> tabIcons = [
    Icons.bookmark_outline,
    Icons.book_outlined,
    Icons.home_outlined,
    Icons.wallet_outlined,
    Icons.person_outline
  ];
  List<Points> getChartData({
    bool isMiniGraph = false,
    required Random random,
  }) {
    return [
      if (!isMiniGraph) Points(x: 0, y: 9985),
      for (int i = 1; i < (!isMiniGraph ? 20 : 10); i++)
        Points(
            x: i.toDouble(),
            y: 9995 +
                random.nextInt(10000 - 9995).toDouble() +
                random.nextDouble()),
    ];
  }

  void notify() {
    notifyListeners();
  }

  // List<Points> chartData = [
  //   for (int i = 0; i < 5; i++)
  //     Points(
  //         x: i.toDouble(),
  //         y: 9995 + random.nextInt(10000 - 9995).roundToDouble()),
  // ];
}

class Points {
  Points({
    required this.x,
    required this.y,
  });
  double x;
  double y;
}
