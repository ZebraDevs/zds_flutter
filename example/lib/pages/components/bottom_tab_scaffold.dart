import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class BottomTabScaffoldDemo extends StatelessWidget {
  const BottomTabScaffoldDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZdsBottomTabScaffold(
      tabs: const [
        ZdsNavItem(
          icon: IconWithBadge(
            Icons.article_outlined,
            unread: 4,
            semanticsLabel: '4 unread forms',
          ),
          label: 'Forms',
        ),
        ZdsNavItem(
          icon: IconWithBadge(
            Icons.search,
          ),
          label: 'Search',
        ),
        ZdsNavItem(
          icon: IconWithBadge(
            Icons.analytics_outlined,
            unread: 50000,
            maximumDigits: 4,
          ),
          label: 'Reports',
        ),
      ],
      bodyBuilder: (context, index) => Center(child: Text(index.toString())),
    );
  }
}
