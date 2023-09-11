import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class AppBarDemo extends StatefulWidget {
  const AppBarDemo({Key? key}) : super(key: key);

  @override
  _AppBarDemoState createState() => _AppBarDemoState();
}

class _AppBarDemoState extends State<AppBarDemo> with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ZdsTabBar(
      controller: controller,
      tabs: const [
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
      ],
    );
    final actions = [
      IconButton(
        onPressed: () {},
        icon: const Icon(ZdsIcons.edit),
      ),
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZdsAppBar(
              title: const Text('Primary color scheme'),
              subtitle: const Text('Subtitle!'),
              icon: CircleAvatar(
                radius: 15,
                backgroundColor: ZdsColors.white,
                child: Text(
                  'DM',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: actions,
              bottom: tabs,
            ),
            ZdsAppBar(
              color: ZdsTabBarColor.basic,
              title: const Text('Basic color scheme'),
              icon: CircleAvatar(
                radius: 15,
                backgroundColor: ZdsColors.white,
                child: Text(
                  'DM',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: const Text('Subtitle!'),
              actions: actions,
              bottom: tabs,
            ),
            ZdsAppBar(
              title: const Text('Surface color scheme'),
              subtitle: const Text('Subtitle!'),
              color: ZdsTabBarColor.surface,
              icon: CircleAvatar(
                radius: 15,
                backgroundColor: ZdsColors.white,
                child: Text(
                  'DM',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: actions,
              bottom: tabs,
            ),
          ].divide(const SizedBox(height: 40)).toList(),
        ),
      ),
    );
  }
}
