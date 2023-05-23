import 'package:ajay_flutter_web_task/app_provider.dart';
import 'package:ajay_flutter_web_task/theme.dart';
import 'package:ajay_flutter_web_task/widgets/graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class WatchlistOverview extends StatelessWidget {
  const WatchlistOverview({super.key, this.isMobile = false});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    // AppProvider appProvider = context.read<AppProvider>();
    // List<Points> points = appProvider.getChartData(random: Random());
    return Padding(
      padding: EdgeInsets.all(!isMobile ? 0 : 12.0),
      child: Consumer(
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
          Wrap(
            runSpacing: 30,
            children: [
              Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppTheme.boxShadow,
                    ),
                    child: SizedBox(
                      // width: 300,
                      // height: 400,
                      child: Container(
                        height: 42,
                        width: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Colors.red, Colors.pink]),
                          // color: Colors.pinkAccent.shade400,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            const BoxShadow(
                              color: Color(0x0f101828),
                              blurRadius: 7,
                              offset: Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.pink.shade300,
                              blurRadius: 14,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Trade",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppTheme.boxShadow,
                    ),
                    child: const SizedBox(width: 300, height: 400),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppTheme.boxShadow,
                    ),
                    child: const SizedBox(width: 300, height: 400),
                  ),
                  const SizedBox(height: 20),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppTheme.boxShadow,
                    ),
                    child: const SizedBox(width: 300, height: 400),
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
