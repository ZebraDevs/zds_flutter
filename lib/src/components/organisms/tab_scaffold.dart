import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'bottom_tab_bar.dart';

/// Scaffold with built in support for bottom tabs.
///
/// Example using [bodyBuilder]:
/// ```dart
/// ZdsBottomTabScaffold(
///   tabs: [
///     ZdsNavItem(
///         icon: const Icon(Icons.search),
///         label: 'Search',
///         ),
///     ZdsNavItem(
///         icon: const Icon(Icons.analytics_outlined),
///         label: 'Reports',
///        ),
///   ],
///   bodyBuilder: (context, index) => Center(child: Text(index.toString())),
/// );
/// ```
///
/// Example using [children]:
/// ```dart
/// ZdsBottomTabScaffold(
///   tabs: [
///     ZdsNavItem(
///         icon: const Icon(Icons.search),
///         label: 'Search',
///         ),
///     ZdsNavItem(
///         icon: const Icon(Icons.analytics_outlined),
///         label: 'Reports',
///        ),
///   ],
///  children: const [Center(child: Text('Search')), Center(child: Text('Reports'))],
/// );
/// ```
///
/// See also:
///   * [ZdsBottomTabBar] - To use a bottom tab bar without a scaffold.
///   * [ZdsNavItem]
class ZdsBottomTabScaffold extends StatefulWidget {
  /// Builds a scaffold with built in support for bottom tabs.
  const ZdsBottomTabScaffold({
    required this.tabs,
    super.key,
    this.children,
    this.bodyBuilder,
    this.onTabChange,
  })  : assert(
          (children != null && bodyBuilder == null) || (children == null && bodyBuilder != null),
          'You can have either children or a bodyBuilder, not both.',
        ),
        assert(
          children != null && tabs.length == children.length || children == null,
          'The size of children and tabs must be the same',
        );

  /// List of [ZdsNavItem].
  final List<ZdsNavItem> tabs;

  /// List of views.
  ///
  /// The list index corresponds to the tab.
  ///
  /// __You can have either children or a bodyBuilder, not both.__
  final List<Widget>? children;

  /// Builder function to create the body of the page.
  ///
  /// __You can have either children or a bodyBuilder, not both.__
  ///
  /// * `context` is the build context of the view.
  ///
  /// * `index` is the index of the selected tab.
  final Widget Function(BuildContext context, int index)? bodyBuilder;

  /// Callback function for whenever the tab is changed.
  ///
  /// Returns the index of the selected tab.
  final void Function(int)? onTabChange;

  @override
  ZdsBottomTabScaffoldState createState() => ZdsBottomTabScaffoldState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<ZdsNavItem>('tabs', tabs))
      ..add(ObjectFlagProperty<Widget Function(BuildContext context, int index)?>.has('bodyBuilder', bodyBuilder))
      ..add(ObjectFlagProperty<void Function(int p1)?>.has('onTabChange', onTabChange));
  }
}

/// State for [ZdsBottomTabScaffold].
class ZdsBottomTabScaffoldState extends State<ZdsBottomTabScaffold> {
  int _currentIndex = 0;
  void _handleTap(int index) {
    widget.onTabChange?.call(index);
    setState(() {
      _currentIndex = index;
    });
  }

  Widget? _resolveChild() {
    if (widget.bodyBuilder != null) {
      return widget.bodyBuilder!(context, _currentIndex);
    } else {
      if (widget.children!.length - 1 >= _currentIndex) {
        return widget.children![_currentIndex];
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _resolveChild(),
      bottomNavigationBar: ZdsBottomTabBar(
        onTap: _handleTap,
        currentIndex: _currentIndex,
        items: widget.tabs,
      ),
    );
  }
}
