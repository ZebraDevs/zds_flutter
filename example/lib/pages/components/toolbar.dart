import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class ToolBarDemo extends StatefulWidget {
  const ToolBarDemo({Key? key}) : super(key: key);

  @override
  State<ToolBarDemo> createState() => _ToolBarDemoState();
}

class _ToolBarDemoState extends State<ToolBarDemo> {
  DateTimeRange? r = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7)));

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZdsToolbar(
              title: ZdsDateRange(
                emptyLabel: 'Select range',
                isWeekMode: true,
                actions: [
                  ZdsButton.text(
                    child: Text(' View'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            ZdsToolbar(
              backgroundColor: zetaColors.iconDefault,
              title: ZdsDateRange(
                emptyLabel: 'Select range',
                isSelectable: false,
                initialDateRange: r,
                onChange: (r1) => setState(() => r = r1),
                actions: [
                  ZdsButton.text(
                    child: Text('Fiscal View', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            ZdsToolbar(
              backgroundColor: zetaColors.primary,
              title: ZdsDateRange(
                emptyLabel: 'Select range',
                initialDateRange: r,
                onChange: (r1) => setState(() => r = r1),
                actions: [
                  ZdsButton.text(
                    child: Text('Fiscal View', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                    onTap: () {},
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(ZdsIcons.filter),
                ),
              ],
              child: const DefaultTabController(
                length: 4,
                child: ZdsTabBar(
                  color: ZdsTabBarColor.primary,
                  tabs: [
                    ZdsTab(
                      label: 'All',
                    ),
                    ZdsTab(
                      label: 'New',
                    ),
                    ZdsTab(
                      label: 'Urgent',
                    ),
                    ZdsTab(
                      label: 'Overdue',
                    ),
                  ],
                ),
              ),
            ),
            ZdsToolbar(
              backgroundColor: zetaColors.yellow.surface,
              title: ZdsDateRange(
                textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: zetaColors.yellow.selected,
                    ),
                initialDateRange: DateTimeRange(
                  start: DateTime(2022, 05, 12),
                  end: DateTime(2022, 05, 18),
                ),
                //isSelectable: false,
              ),
            ),
            ZdsToolbar(
              title: const Text('SR-CHI-Downers Grove IL.00103'),
              subtitle: const Text('04/01/2021 - 04/30/2021'),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(ZdsIcons.filter),
                ),
              ],
              child: Container(
                color: Theme.of(context).colorScheme.surfacePrimary,
                height: 400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
