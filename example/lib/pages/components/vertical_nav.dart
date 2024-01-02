import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class VerticalNavDemo extends StatefulWidget {
  const VerticalNavDemo({Key? key}) : super(key: key);

  @override
  State<VerticalNavDemo> createState() => _VerticalNavDemoState();
}

class _VerticalNavDemoState extends State<VerticalNavDemo> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final verticalNav = ZdsVerticalNav(
      currentIndex: selectedIndex,
      onTap: (index) => setState(() {
        selectedIndex = index;
      }),
      items: const [
        ZdsNavItem(label: 'user', semanticLabel: 'user', icon: Icon(ZdsIcons.user)),
        ZdsNavItem(label: 'calendar', semanticLabel: 'calendar', icon: Icon(ZdsIcons.calendar)),
        ZdsNavItem(label: 'vacation', semanticLabel: 'vacation', icon: Icon(ZdsIcons.vacation)),
        ZdsNavItem(label: 'star', semanticLabel: 'star', icon: Icon(ZdsIcons.star)),
        ZdsNavItem(label: 'more', semanticLabel: 'more', icon: Icon(ZdsIcons.more_hori)),
      ],
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Icon(
            ZdsIcons.pin,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Icon(
            ZdsIcons.task,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Icon(
            ZdsIcons.chat,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Icon(
            ZdsIcons.walk,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Icon(
            ZdsIcons.grid,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalNav,
          Expanded(
            child: Center(
              child: SizedBox(
                height: 500,
                child: verticalNav,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
