import 'package:ajay_flutter_web_task/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.read<AppProvider>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: appProvider.activeTab,
        builder: (_, newAppNavValue, __) => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: appProvider.tabTitle
              .map((e) => InkWell(
                    onTap: () {
                      appProvider.activeTab.value =
                          appProvider.tabTitle.indexOf(e);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          Icon(
                            appProvider
                                .tabIcons[appProvider.tabTitle.indexOf(e)],
                            color: appProvider.activeTab.value ==
                                    appProvider.tabTitle.indexOf(e)
                                ? Colors.blue
                                : Colors.grey,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.read<AppProvider>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.withOpacity(0.1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ValueListenableBuilder<int>(
        valueListenable: appProvider.activeTab,
        builder: (_, newAppNavValue, __) => Row(
          children: appProvider.tabTitle
              .map((e) => e == "Watchlist"
                  ? Expanded(
                      child: Theme(
                        data: ThemeData(
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              for (int i = 0; i < 4; i++)
                                (PopupMenuItem(
                                  child: Text("Watchlist ${i + 1}"),
                                  onTap: () {
                                    appProvider.activeWatchlist = i;
                                    appProvider.activeTab.value = 0;
                                    appProvider.indexList.shuffle();
                                    appProvider.notify();
                                  },
                                ))
                            ];
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              Icon(
                                appProvider
                                    .tabIcons[appProvider.tabTitle.indexOf(e)],
                                color: appProvider.activeTab.value ==
                                        appProvider.tabTitle.indexOf(e)
                                    ? Colors.blue
                                    : Colors.grey,
                                size: 28,
                              ),
                              const SizedBox(height: 5),
                              if (appProvider.tabTitle.indexOf(e) ==
                                  appProvider.activeTab.value)
                                Column(
                                  children: [
                                    Consumer(
                                      builder: (context,
                                              AppProvider appProvider, child) =>
                                          Text(
                                        "$e ${appProvider.activeWatchlist + 1}",
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      width: 20,
                                      height: 2,
                                      color: Colors.blue,
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          appProvider.activeTab.value =
                              appProvider.tabTitle.indexOf(e);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            Icon(
                              appProvider
                                  .tabIcons[appProvider.tabTitle.indexOf(e)],
                              color: appProvider.activeTab.value ==
                                      appProvider.tabTitle.indexOf(e)
                                  ? Colors.blue
                                  : Colors.grey,
                              size: 28,
                            ),
                            const SizedBox(height: 5),
                            if (appProvider.tabTitle.indexOf(e) ==
                                appProvider.activeTab.value)
                              Column(
                                children: [
                                  Text(
                                    e,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    width: 20,
                                    height: 2,
                                    color: Colors.blue,
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                    ))
              .toList(),
        ),
      ),
    );
  }
}
