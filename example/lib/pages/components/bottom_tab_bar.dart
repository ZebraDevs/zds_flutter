import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class BottomTabBarDemo extends StatefulWidget {
  const BottomTabBarDemo({Key? key}) : super(key: key);

  @override
  _BottomTabBarDemoState createState() => _BottomTabBarDemoState();
}

class _BottomTabBarDemoState extends State<BottomTabBarDemo> {
  int currentIndex = 0;
  static const _boxSize = 120.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: _boxSize,
                width: _boxSize,
                color: Theme.of(context).colorScheme.primary,
                child: IconWithBadge(
                  Icons.article_outlined,
                  unread: 4,
                  size: 60,
                  iconContainerColor: Theme.of(context).colorScheme.primary,
                  semanticsLabel: '4 unread forms',
                ),
              ),
              Container(
                height: _boxSize,
                width: _boxSize,
                color: Theme.of(context).colorScheme.surface,
                child: IconWithBadge(
                  Icons.article_outlined,
                  unread: 40,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                  semanticsLabel: '4 unread forms',
                ),
              ),
              Container(
                height: _boxSize,
                width: _boxSize,
                color: Theme.of(context).colorScheme.secondary,
                child: IconWithBadge(
                  Icons.article_outlined,
                  unread: 100,
                  size: 60,
                  iconContainerColor: Theme.of(context).colorScheme.secondary,
                  semanticsLabel: '4 unread forms',
                ),
              )
            ].map((e) {
              return ZdsCard(
                padding: EdgeInsets.zero,
                child: e,
              );
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar: ZdsBottomTabBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          ZdsNavItem(
              icon: IconWithBadge(
                Icons.article_outlined,
                unread: 4,
                semanticsLabel: '4 unread forms',
              ),
              label: 'Forms'),
          ZdsNavItem(
              icon: IconWithBadge(
                Icons.search,
              ),
              label: 'Search'),
          ZdsNavItem(
              icon: IconWithBadge(
                Icons.analytics_outlined,
                unread: 50000,
                maximumDigits: 4,
              ),
              label: 'Reports'),
        ],
      ),
    );
  }
}
