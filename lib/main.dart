import 'package:ajay_flutter_web_task/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'watchlist.dart';

void main() {
  runApp(
    MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
        child: const WatchList()),
  );
}
