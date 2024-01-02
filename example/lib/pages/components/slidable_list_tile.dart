import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class SlidableListTileDemo extends StatelessWidget {
  const SlidableListTileDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var zetaColors = Zeta.of(context).colors;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            ZdsSlidableListTile(
              onTap: () => debugPrint('Main tile tap'),
              width: MediaQuery.of(context).size.width,
              actions: [
                ZdsSlidableAction(
                  label: 'More',
                ),
                ZdsSlidableAction(
                    icon: ZdsIcons.sign_out,
                    label: 'Exit',
                    onPressed: (_) => debugPrint('Exit'),
                    backgroundColor: themeData.colorScheme.error,
                    foregroundColor: themeData.colorScheme.onError)
              ],
              child: const _ExampleContent(
                leading: CircleAvatar(child: Text('JC')),
                title: 'Title',
                subtitle: 'Subtitle',
                trailing: Text('Trailing'),
              ),
            ),
            const SizedBox(height: 12),
            ZdsSlidableListTile(
              slideButtonWidth: 120,
              backgroundColor: const Color(0xFFFFE440),
              width: MediaQuery.of(context).size.width,
              leadingActions: [
                ZdsSlidableAction(
                    icon: Icons.restaurant,
                    label: 'Kadabra',
                    backgroundColor: const Color(0xFF6D534E),
                    foregroundColor: Colors.white),
                ZdsSlidableAction(
                  icon: Icons.flatware,
                  label: 'Alakazam',
                  backgroundColor: const Color(0xFFC0C0C0),
                )
              ],
              actions: [
                ZdsSlidableAction(
                    icon: Icons.restaurant,
                    label: 'Kadabra',
                    backgroundColor: const Color(0xFF6D534E),
                    foregroundColor: Colors.white),
                ZdsSlidableAction(
                  icon: Icons.flatware,
                  label: 'Alakazam',
                  backgroundColor: const Color(0xFFC0C0C0),
                )
              ],
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Abra'), Icon(Icons.no_meals, color: Colors.black)],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 55,
              child: ZdsSlidableListTile(
                slideButtonWidth: 120,
                backgroundColor: const Color(0xFFFFE440),
                width: MediaQuery.of(context).size.width,
                leadingActions: [
                  ZdsSlidableAction(
                    label: 'Kadabra',
                    backgroundColor: const Color(0xFF6D534E),
                    foregroundColor: Colors.white,
                  ),
                  ZdsSlidableAction(
                    label: 'Alakazam',
                    backgroundColor: const Color(0xFFC0C0C0),
                  )
                ],
                actions: [
                  ZdsSlidableAction(
                      icon: Icons.restaurant,
                      label: 'Kadabra',
                      backgroundColor: const Color(0xFF6D534E),
                      foregroundColor: Colors.white),
                  ZdsSlidableAction(
                    icon: Icons.flatware,
                    label: 'Alakazam',
                    backgroundColor: const Color(0xFF6D534E),
                    foregroundColor: Colors.white,
                  )
                ],
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('A compressed list tile'), Icon(Icons.no_meals, color: Colors.black)],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: ZdsSlidableListTile(
                slideButtonWidth: 120,
                backgroundColor: zetaColors.red,
                width: MediaQuery.of(context).size.width,
                actions: [
                  ZdsSlidableAction(
                    label: 'Give away',
                    backgroundColor: themeData.colorScheme.secondary,
                    foregroundColor: themeData.colorScheme.secondary.onColor,
                  ),
                  ZdsSlidableAction(
                    label: 'Direct swap',
                    backgroundColor: zetaColors.purple,
                    foregroundColor: zetaColors.purple.onColor,
                  ),
                  ZdsSlidableAction(
                      label: 'Swap with anyone',
                      backgroundColor: themeData.colorScheme.secondaryContainer,
                      foregroundColor: themeData.colorScheme.secondaryContainer.onColor,
                      textOverflow: TextOverflow.visible)
                ],
                child: const Center(child: Text('A list tile with 3 slidable action buttons')),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ExampleContent extends StatelessWidget {
  const _ExampleContent({
    Key? key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  }) : super(key: key);

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) leading!,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 6),
                if (title != null)
                  Text(
                    title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      subtitle ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!
        ],
      ),
    );
  }
}
