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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZdsToolbar(
              title: DateRange(
                emptyLabel: 'Select range',
                isWeekMode: true,
                actions: [
                  ZdsButton.text(
                    child: Text(' View', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            ZdsToolbar(
              title: DateRange(
                emptyLabel: 'Select range',
                isSelectable: false,
                initialDateRange: r,
                onChange: (r1) {
                  setState(() => r = r1);
                },
                actions: [
                  ZdsButton.text(
                    child: Text('Fiscal View', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            ZdsToolbar(
              title: DateRange(
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
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: DateRange(
                textStyle: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary),
                initialDateRange: DateTimeRange(
                  start: DateTime(2022, 05, 12),
                  end: DateTime(2022, 05, 18),
                ),
                isSelectable: false,
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
                color: Theme.of(context).colorScheme.primary,
                height: 400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
