import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../zds_flutter.dart';

/// Creates a popup menu.
///
/// This component is typically used to display more options that do not fit in a [ZdsAppBar], or to show more
/// options in a specific widget, like a [ZdsListTile]
///
/// This popup menu should typically be populated with [ZdsPopupMenuItem].
///
/// ```dart
/// ZdsPopupMenu(
///   onSelected: (String value) => manageValue(value),
///   builder: (context, open) => IconButton(
///     onPressed: open,
///     icon: Icon(ZdsIcons.more_vert),
///   ),
///   items: [
///     ZdsPopupMenuItem(
///       value: 'Week',
///       child: ListTile(title: Text('Week')),
///     ),
///     ZdsPopupMenuItem(
///       value: 'Month',
///       child: ListTile(title: Text('Month')),
///     ),
///   ],
/// ),
/// ```
///
/// See also:
///
///  * [ZdsPopupMenuItem], used to create the options that appear in this menu.
///  * [ZdsAppBar], where this component is used to show more actions that do not typically fit.
class ZdsPopupMenu<T> extends StatefulWidget {
  /// Creates a pop up menu.
  const ZdsPopupMenu({
    required this.builder,
    required this.items,
    super.key,
    this.onCanceled,
    this.onSelected,
  }) : assert(items.length > 0, 'Must have at least 1 item');

  /// Defines how this component will appear on screen.
  ///
  /// Typically builds an [IconButton].
  final Widget Function(BuildContext, VoidCallback) builder;

  /// The options that will appear when this menu is tapped.
  ///
  /// See [ZdsPopupMenuItem].
  ///
  /// Must not be empty.
  final List<PopupMenuEntry<T>> items;

  /// A function called whenever an item is selected.
  final PopupMenuItemSelected<T>? onSelected;

  /// A function called whenever the user doesn't select an item and instead closes the menu.
  final PopupMenuCanceled? onCanceled;

  @override
  ZdsPopupMenuState<T> createState() => ZdsPopupMenuState<T>();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<Widget Function(BuildContext p1, VoidCallback p2)>.has('builder', builder))
      ..add(ObjectFlagProperty<PopupMenuItemSelected<T>?>.has('onSelected', onSelected))
      ..add(ObjectFlagProperty<PopupMenuCanceled?>.has('onCanceled', onCanceled));
  }
}

/// State for [ZdsPopupMenu].
class ZdsPopupMenuState<T> extends State<ZdsPopupMenu<T>> {
  final GlobalKey _key = GlobalKey();

  Null Function() _showButtonMenu(BuildContext context) => () {
        final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
        if (_key.currentContext == null ||
            _key.currentContext?.findRenderObject() == null ||
            Navigator.of(context).overlay == null ||
            Navigator.of(context).overlay?.context.findRenderObject() == null) {
          return;
        }
        final RenderBox button = _key.currentContext!.findRenderObject()! as RenderBox;
        final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
            button.localToGlobal(
              button.size.bottomRight(Offset.zero) + Offset(0, button.size.height),
              ancestor: overlay,
            ),
          ),
          Offset.zero & overlay.size,
        );
        final List<PopupMenuEntry<T>> items = widget.items;
        // Only show the menu if there is something to show
        if (items.isNotEmpty) {
          unawaited(
            showMenu<T>(
              context: context,
              elevation: popupMenuTheme.elevation,
              items: items,
              position: position,
              shape: popupMenuTheme.shape,
              color: popupMenuTheme.color,
            ).then<void>((T? newValue) {
              if (!mounted) return null;
              if (newValue == null) {
                widget.onCanceled?.call();
                return null;
              }
              widget.onSelected?.call(newValue);
            }),
          );
        }
      };

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      dense: true,
      child: Material(
        color: Colors.transparent,
        child: Builder(
          key: _key,
          builder: (BuildContext context) => IconTheme(
            data: Theme.of(context).primaryIconTheme,
            child: widget.builder(context, _showButtonMenu(context)),
          ),
        ),
      ),
    );
  }
}

/// A component used to create the options that appear when using [ZdsPopupMenu].
///
/// The contents of an item are typically created using [ListTile].
///
/// ```dart
/// ZdsPopupMenuItem(
///   value: 'Week',
///   child: ListTile(title: Text('Week')),
/// ),
/// ```
///
/// See also:
///
///  * [ZdsPopupMenu], used to create popup menus.
class ZdsPopupMenuItem<T> extends PopupMenuItem<T> {
  /// Constructs a [ZdsPopupMenuItem].
  const ZdsPopupMenuItem({
    required Widget super.child,
    super.key,
    super.value,
    super.enabled,
    super.height,
    super.padding,
    super.textStyle,
  });
}
