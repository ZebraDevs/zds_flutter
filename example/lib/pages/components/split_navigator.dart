import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class SplitNavigatorDemo extends StatefulWidget {
  const SplitNavigatorDemo({Key? key}) : super(key: key);

  @override
  State<SplitNavigatorDemo> createState() => _SplitNavigatorDemoState();
}

class _SplitNavigatorDemoState extends State<SplitNavigatorDemo> {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int currentIndex) {
    if (_currentIndex == currentIndex) return;
    setState(() {
      _currentIndex = currentIndex;
    });
  }

  int selectedKey = -1;

  @override
  Widget build(BuildContext context) {
    final items = [
      const ZdsNavItem(label: 'Tab 1', icon: Icon(ZdsIcons.task)),
      const ZdsNavItem(label: 'Tab 2', icon: Icon(ZdsIcons.category))
    ];

    return Scaffold(
      body: Row(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            child: context.isTablet()
                ? ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 56),
                    child: Scaffold(
                      body: ZdsVerticalNav(
                        barWidth: 56,
                        items: items,
                        currentIndex: currentIndex,
                        onTap: onTap,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: ZdsSplitNavigator(
              shouldSplit: kIsWeb || (context.isTablet() && context.isLandscape()),
              maxPrimaryWidth: 480,
              emptyBuilder: (context) {
                return const Scaffold(
                  body: ZdsEmpty(message: Text('Nothing selected!')),
                );
              },
              primaryWidget: Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  centerTitle: true,
                  title: const Text('Primary'),
                ),
                body: SafeArea(
                  right: false,
                  child: ZdsList.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return ZdsListTile(
                        title: Text('Feed ${index + 1}'),
                        onTap: () {
                          final route = ZdsNoAnimationPageRouteBuilder(
                            builder: (context) {
                              return FeedPage(feedTitle: 'Feed ${index + 1}');
                            },
                          );

                          ZdsSplitNavigator.pushDetails(context, route);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: context.isTablet()
          ? null
          : ZdsBottomTabBar(
              currentIndex: currentIndex,
              onTap: onTap,
              items: items,
            ),
    );
  }

  void onTap(int index) {
    currentIndex = index;
  }
}

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key, required this.feedTitle}) : super(key: key);

  final String feedTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(feedTitle)),
      body: Center(
        child: ZdsButton.filled(
          child: const Text('Next'),
          onTap: () {
            Navigator.of(context).push(
              ZdsSplitPageRouteBuilder(
                builder: (context) {
                  return FeedPage(feedTitle: "$feedTitle>${feedTitle.split(">").first}");
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
