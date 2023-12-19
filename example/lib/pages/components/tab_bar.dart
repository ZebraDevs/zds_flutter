import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class TabBarDemo extends StatefulWidget {
  const TabBarDemo({Key? key}) : super(key: key);

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

extension demo on ZdsTab {
  ZdsTab get withoutIcon {
    return ZdsTab(child: child, label: label, key: key);
  }

  ZdsTab get withoutText {
    return ZdsTab(child: child, icon: icon, key: key);
  }
}

class _TabBarDemoState extends State<TabBarDemo> with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const items2 = const [
      ZdsTab(
        icon: Icon(ZdsIcons.details),
        label: 'Details',
      ),
      ZdsTab(
        icon: Icon(ZdsIcons.edit),
        label: 'Edit',
      ),
      ZdsTab(
        icon: Icon(ZdsIcons.delete),
        label: 'Discard',
      ),
      ZdsTab(
        icon: Icon(ZdsIcons.unclaim),
        label: 'Unclaim',
      ),
      ZdsTab(
        icon: Icon(ZdsIcons.history),
        label: 'History',
      ),
    ];
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Colors: primary, basic, surface', style: Theme.of(context).textTheme.displaySmall),
              Text('ZdsTabBar with icons', style: Theme.of(context).textTheme.displaySmall),
              ZdsTabBar(color: ZdsTabBarColor.primary, tabs: items2),
              ZdsTabBar(color: ZdsTabBarColor.basic, tabs: items2),
              ZdsCard(
                child: ZdsTabBar(
                  isScrollable: true,
                  color: ZdsTabBarColor.surface,
                  tabs: items2,
                ),
              ),
              Text('ZdsResponsiveTabBar with icons', style: Theme.of(context).textTheme.displaySmall),
              ZdsCard(
                child: ZdsResponsiveTabBar(color: ZdsTabBarColor.surface, tabs: items2),
              ),
              Center(
                child: SizedBox(
                  width: 345,
                  child: Column(
                    children: [
                      ZdsResponsiveTabBar(color: ZdsTabBarColor.primary, tabs: items2),
                      ZdsResponsiveTabBar(color: ZdsTabBarColor.basic, tabs: items2),
                      ZdsResponsiveTabBar(color: ZdsTabBarColor.surface, tabs: items2),
                    ],
                  ),
                ),
              ),
              Text('ZdsTabBar without icons', style: Theme.of(context).textTheme.displaySmall),
              ZdsTabBar(color: ZdsTabBarColor.primary, tabs: items2.map((e) => e.withoutIcon).toList()),
              ZdsTabBar(color: ZdsTabBarColor.basic, tabs: items2.map((e) => e.withoutIcon).toList()),
              ZdsTabBar(color: ZdsTabBarColor.surface, tabs: items2.map((e) => e.withoutIcon).toList()),
              Text('ZdsResponsiveTabBar without icons', style: Theme.of(context).textTheme.displaySmall),
              Center(
                child: SizedBox(
                  width: 345,
                  child: Column(
                    children: [
                      ZdsResponsiveTabBar(
                          color: ZdsTabBarColor.primary, tabs: items2.map((e) => e.withoutIcon).toList()),
                      ZdsResponsiveTabBar(color: ZdsTabBarColor.basic, tabs: items2.map((e) => e.withoutIcon).toList()),
                      ZdsResponsiveTabBar(
                          color: ZdsTabBarColor.surface, tabs: items2.map((e) => e.withoutIcon).toList()),
                    ],
                  ),
                ),
              ),
              Text('ZdsTabBar without text', style: Theme.of(context).textTheme.displaySmall),
              ZdsTabBar(color: ZdsTabBarColor.primary, tabs: items2.map((e) => e.withoutText).toList()),
              ZdsTabBar(color: ZdsTabBarColor.basic, tabs: items2.map((e) => e.withoutText).toList()),
              ZdsTabBar(color: ZdsTabBarColor.surface, tabs: items2.map((e) => e.withoutText).toList()),
              Text('ZdsResponsiveTabBar without text', style: Theme.of(context).textTheme.displaySmall),
              Center(
                child: SizedBox(
                  width: 245,
                  child: Column(
                    children: [
                      ZdsResponsiveTabBar(
                          color: ZdsTabBarColor.primary, tabs: items2.map((e) => e.withoutText).toList()),
                      ZdsResponsiveTabBar(color: ZdsTabBarColor.basic, tabs: items2.map((e) => e.withoutText).toList()),
                      ZdsResponsiveTabBar(
                          color: ZdsTabBarColor.surface, tabs: items2.map((e) => e.withoutText).toList()),
                    ],
                  ),
                ),
              ),
            ].divide(const SizedBox(height: 40)).toList(),
          ),
        ),
        bottomNavigationBar: ZdsResponsiveTabBar(
          color: ZdsTabBarColor.surface,
          tabs: items2.map((e) => e.withoutText).toList(),
        ),
      ),
    );
  }
}
