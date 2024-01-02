import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class BottomSheetDemo extends StatefulWidget {
  const BottomSheetDemo({Key? key}) : super(key: key);

  @override
  _BottomSheetDemoState createState() => _BottomSheetDemoState();
}

class _BottomSheetDemoState extends State<BottomSheetDemo> with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ZdsList(
        children: [
          ZdsButton(
            onTap: bottomSheetUsingBuildSheetBars,
            child: const Text('bottom sheet for Tablet and Mobile'),
          ),
          ZdsButton(
            onTap: bottomSheetUsingBuildSheetBars2,
            child: const Text('bottom sheet for Tablet and Mobile within builder'),
          ),
          ZdsButton(
            onTap: showBottomSheet1,
            child: const Text('Show with tab bar'),
          ),
          ZdsButton(
            child: const Text('Enforce sheet on Tablets/iPads'),
            onTap: () => showBottomSheet3(enforceSheet: true),
          ),
          ZdsButton.muted(
            onTap: showBottomSheet3,
            child: const Text('Show bottom sheet 5 items'),
          ),
        ].divide(const SizedBox(height: 20)).toList(),
      ),
    );
  }

  void showBottomSheet1() {
    Widget buildList() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ZdsListGroup(
            headerLabel: Text('Search for title, description and unique id'),
            items: [
              ZdsListTile(
                title: Text('Title'),
                trailing: Text('Title'),
              ),
              ZdsListTile(
                title: Text('Priority'),
                trailing: Text('All'),
              ),
            ],
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              title: const Text('Favorite'),
              trailing: Switch(
                onChanged: (v) {},
                value: true,
              ),
            ),
          ),
          ZdsListGroup(
            headerLabel: Text('Event Tags'),
            items: [
              ZdsListTile(
                title: Text('State'),
                subtitle: Text('Active'),
                trailing: Icon(ZdsIcons.chevron_right),
              ),
              ZdsListTile(
                title: Text('Event Type'),
                subtitle: Text('All'),
                trailing: Icon(ZdsIcons.chevron_right),
              ),
              ZdsListTile(
                title: Text('Message Type'),
                subtitle: Text('All stores'),
                trailing: Icon(ZdsIcons.chevron_right),
              ),
            ],
          ),
        ],
      );
    }

    Widget tabView1() {
      return ZdsList(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: buildList(),
          ),
        ],
      );
    }

    Widget tabView2() {
      return const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZdsListGroup(
                    headerLabel: Text('System Filters'),
                    items: [
                      ZdsListTile(
                        title: Text('System (New this week)'),
                      ),
                      ZdsListTile(
                        title: Text('System (New today)'),
                      ),
                      ZdsListTile(
                        title: Text('System (Completed today)'),
                      ),
                      ZdsListTile(
                        title: Text('System (Due today)'),
                      ),
                      ZdsListTile(
                        title: Text('System (Due in the last 7 days)'),
                      ),
                      ZdsListTile(
                        title: Text('System (Due this week)'),
                      ),
                      ZdsListTile(
                        title: Text('System (Favorite)'),
                      ),
                      ZdsListTile(
                        title: Text('System (Informational project)'),
                      ),
                      ZdsListTile(
                        title: Text('System (Overdue)'),
                      ),
                      ZdsListTile(
                        title: Text('System (Project edited)'),
                      ),
                      ZdsListTile(
                        title: Text('System (Upcoming)'),
                      ),
                    ],
                  ),
                  ZdsListGroup(
                    headerLabel: Text('Custom Filters'),
                    items: [
                      ZdsListTile(
                        title: Text('Feeds Action'),
                      ),
                      ZdsListTile(
                        title: Text('Filter 3'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    showZdsBottomSheet(
      context: context,
      headerBuilder: (context) => ZdsTabBar(
        color: ZdsTabBarColor.surface,
        controller: controller,
        tabs: const [
          ZdsTab(
            label: 'Filter',
          ),
          ZdsTab(
            label: 'Saved Filter',
          ),
        ],
      ),
      bottomBuilder: (context) => ZdsBottomBar(
        child: Row(
          children: [
            ZdsButton.text(
              child: const Text('Save'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const Spacer(),
            ZdsButton.outlined(
              child: const Text('Clear'),
              onTap: () {},
            ),
            const SizedBox(width: 8),
            ZdsButton(
              child: const Text('Cancel'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      builder: (context) => ExampleTabView(
        controller: controller,
        children: [
          tabView1(),
          tabView2(),
        ],
      ),
    );
  }

  void showBottomSheet3({bool enforceSheet = false}) {
    showZdsBottomSheet(
      enforceSheet: enforceSheet,
      context: context,
      headerBuilder: (context) => ZdsSheetHeader(headerText: 'Select Priority'),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ZdsListTile(
              leading: Text('Urgent'),
              trailing: ZdsIndex(
                color: Zeta.of(context).colors.red,
                child: Text('U'),
              ),
            ),
            ZdsListTile(
              leading: Text('Height'),
              trailing: ZdsIndex(
                color: Zeta.of(context).colors.orange,
                child: Text('1'),
              ),
            ),
            ZdsListTile(
              leading: const Text('Medium'),
              trailing: ZdsIndex(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: const Text('2'),
              ),
            ),
            ZdsListTile(
              leading: Text('Low'),
              trailing: ZdsIndex(
                color: Zeta.of(context).colors.green,
                child: Text('3'),
              ),
            ),
          ],
        ).paddingOnly(left: 16, right: 16);
      },
    );
  }

  void bottomSheetUsingBuildSheetBars() {
    final List<Widget> sheetBarWidgets = buildSheetBars(
      context: context,
      title: 'Filter',
      primaryActionText: 'Apply',
      primaryActionOnTap: () {},
      secondaryActionText: 'Cancel',
      ternaryActionText: 'Reset',
      ternaryActionOnTap: () {},
      showClose: true,
    );
    final ZdsValueController<DateTime> fromDateController = ZdsValueController<DateTime>();
    final ZdsValueController<DateTime> toDateController = ZdsValueController<DateTime>();
    const bool isDayOff = false;

    showZdsBottomSheet(
      context: context,
      bottomInset: 0,
      builder: (context) {
        final zetaColors = Zeta.of(context).colors;
        final themeData = Theme.of(context);
        return ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Text(
                      'Date range',
                      style: themeData.textTheme.titleSmall?.copyWith(color: zetaColors.textSubtle),
                    ).paddingOnly(left: 8),
                  ),
                  const SizedBox(height: 8),
                  ZdsDateRangePickerTile(
                    initialDateController: fromDateController,
                    finalDateController: toDateController,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ExcludeSemantics(
                        child: Text(
                          'Type',
                          style: themeData.textTheme.titleSmall?.copyWith(
                            color: zetaColors.textSubtle,
                          ),
                        ).paddingOnly(left: 8),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ZdsListGroup(
                    padding: EdgeInsets.zero,
                    items: [
                      Semantics(
                        checked: isDayOff,
                        child: ZdsListTile(
                          title: const Text('Day off'),
                          onTap: () {},
                          trailing: Icon(ZdsIcons.check, color: themeData.colorScheme.secondary),
                        ),
                      ),
                      Semantics(
                        checked: isDayOff,
                        child: ZdsListTile(
                          title: const Text('Time off'),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ).paddingOnly(left: 16, right: 16, top: 12),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
      headerBuilder: (context) => sheetBarWidgets[0] as PreferredSizeWidget,
      bottomBuilder: (context) =>
          sheetBarWidgets.asMap().containsKey(1) ? sheetBarWidgets[1] as PreferredSizeWidget : null,
    );
  }

  void bottomSheetUsingBuildSheetBars2() {
    final List<Widget> sheetBarWidgets = buildSheetBars(
      context: context,
      title: 'Filter',
      primaryActionText: 'Apply',
      primaryActionOnTap: () {},
      secondaryActionText: 'Cancel',
      ternaryActionText: 'Reset',
      ternaryActionOnTap: () {},
      showClose: true,
    );

    final ZdsValueController<DateTime> fromDateController = ZdsValueController<DateTime>();
    final ZdsValueController<DateTime> toDateController = ZdsValueController<DateTime>();
    const bool isDayOff = false;

    showZdsBottomSheet(
      context: context,
      bottomInset: 0,
      maxHeight: 440,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => Column(
        children: [
          sheetBarWidgets[0],
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Text(
                      'Date range',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Zeta.of(context).colors.textSubtle,
                          ),
                    ).paddingOnly(left: 10),
                  ),
                  const SizedBox(height: 8),
                  ZdsDateRangePickerTile(
                    initialDateController: fromDateController,
                    finalDateController: toDateController,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ExcludeSemantics(
                        child: Text(
                          'Type',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Zeta.of(context).colors.textSubtle,
                              ),
                        ).paddingOnly(left: 10),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ZdsListGroup(
                    padding: EdgeInsets.zero,
                    items: [
                      Semantics(
                        checked: isDayOff,
                        child: ZdsListTile(
                          title: const Text('Day off'),
                          onTap: () {},
                          trailing: Icon(ZdsIcons.check, color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      Semantics(
                        checked: isDayOff,
                        child: ZdsListTile(
                          title: const Text('Time off'),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).paddingInsets(const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
          ),
          sheetBarWidgets[1]
        ],
      ),
    );
  }
}

class ExampleTabView extends StatefulWidget {
  final TabController? controller;
  final List<Widget> children;

  const ExampleTabView({Key? key, required this.controller, required this.children}) : super(key: key);

  @override
  _ExampleTabViewState createState() => _ExampleTabViewState();
}

class _ExampleTabViewState extends State<ExampleTabView> with SingleTickerProviderStateMixin {
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = widget.controller!.index;
    widget.controller!.addListener(listener);
  }

  void listener() {
    setState(() {
      index = widget.controller!.index;
    });
  }

  @override
  void dispose() {
    widget.controller!.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.children[index];
  }
}
