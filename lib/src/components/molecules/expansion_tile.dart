// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/assets/icons.dart';
import '../../utils/localizations/translation.dart';
import '../../utils/tools/utils.dart';
import '../atoms/card.dart';

/// Types of expansion tile
enum ExpansionTileType {
  /// When expansion tile can be expanded/collapsed, but is not selectable.
  regular,

  /// When expansion tile can be expanded/collapsed, and is selectable.
  selectable
}

const Duration _kExpand = Duration(milliseconds: 200);

/// A tile that can be expanded and collapsed to reveal further information.
///
/// Typically used to hide information that could clutter the page, like detailed information.
///
/// When using this component in a [ZdsCard], the semantics of all widgets will be grouped together (expected Card
/// behaviour to be read in one go). This means that when in a card, reading the expanded children using TalkBack or
/// VoiceOver is difficult. For accessibility purposes, if you want to use this widget within a card, we instead
/// recommend wrapping the [ZdsExpansionTile] in a container with custom decoration so the children remain
/// individually accessible through TalkBack like so:
///
/// ```dart
/// Container(
///   decoration: CustomDecoration(),
///   child: ZdsExpansionTile(
///     title: const Text('Tile outside of a card'),
///     child: Column(
///       crossAxisAlignment: CrossAxisAlignment.start,
///       children: [
///         Text('Child'),
///         Text('Another child'),
///       ],
///     ),
///   ),
/// )
/// ```

class ZdsExpansionTile extends StatefulWidget {
  /// A tile that can be expanded and collapsed to reveal further information.
  const ZdsExpansionTile({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.bottom,
    this.initiallyExpanded = false,
    this.maintainState = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.onExpanded,
    this.onCollapse,
    this.onCollapsed,
    this.showDivider = true,
    this.expandWithIconOnly = false,
    this.hideExpansionSemantics = false,
    this.isExpandable = true,
    this.titleColor = Colors.transparent,
  })  : expansionTileType = ExpansionTileType.regular,
        selected = false,
        onSelected = null;

  /// A selectable tile that can be expanded and collapsed to reveal further information.
  const ZdsExpansionTile.selectable({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.bottom,
    this.initiallyExpanded = false,
    this.maintainState = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.onExpanded,
    this.onCollapse,
    this.onCollapsed,
    this.selected = false,
    this.onSelected,
    this.showDivider = true,
    this.expandWithIconOnly = false,
    this.hideExpansionSemantics = false,
    this.isExpandable = true,
    this.titleColor = Colors.transparent,
  }) : expansionTileType = ExpansionTileType.selectable;

  /// The title of this expansion tile. This title will always be shown.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? subtitle;

  /// The widget to show when the tile is in the expanded state.
  ///
  /// Typically a [Column] with other children.
  final Widget child;

  /// The bottom widget similiar to list tile so the widgets do not interfere with expansion button
  ///
  /// Typically a [Row] with other children or single widget.
  final Widget? bottom;

  /// Whether the tile is expanded when it's first drawn or not.
  ///
  /// Defaults to false.
  final bool initiallyExpanded;

  /// Specifies whether the state of the children is maintained when the tile expands and collapses.
  ///
  /// When true (default), the children are kept in the tree while the tile is collapsed.
  /// When false, the children are removed from the tree when the tile is
  /// collapsed and recreated upon expansion.
  final bool maintainState;

  /// Empty space to inscribe inside this widget.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 24, vertical: 2)`.
  final EdgeInsets contentPadding;

  /// Padding surrounding the title of the widget.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 24, vertical: 16)`.
  final EdgeInsets titlePadding;

  /// A function called whenever the tile is toggled to its expanded state.
  final VoidCallback? onExpanded;

  /// A function called whenever the tile is toggled to its collapsed state.
  final VoidCallback? onCollapse;

  /// A function called whenever the tile is toggled to its collapsed state and animation is finished.
  final VoidCallback? onCollapsed;

  /// Whether the expansion tile is selected or not. Defaults to false.
  final bool selected;

  /// A function called whenever an item is selected.
  final void Function(bool)? onSelected;

  /// Boolean to show divider between expansion tiles.
  ///
  /// Defaults to true.
  final bool showDivider;

  /// If true, tapping the down chevron will toggle the tile expansion, if false tapping anywhere on the tile will.
  ///
  /// Defaults to false.
  final bool expandWithIconOnly;

  /// If true, a semantics service such as Talkback / VoiceOver will ignore the expand button.
  ///
  /// Typically used if the content of the expansion is provided to this service in another way.
  final bool hideExpansionSemantics;

  /// Determines if the user can expand the tile, or if it should behave like a regular tile.
  ///
  /// Typically used in a list when some tiles are expandable but some are not for UI consistencny.
  final bool isExpandable;

  /// Type of expansion tile.
  ///
  /// Defaults to [ExpansionTileType.regular].
  final ExpansionTileType expansionTileType;

  /// Determines the background color of the title part of the expansion tile.
  ///
  /// Defaults to [Colors.transparent].
  final Color titleColor;

  @override
  ZdsExpansionTileState createState() => ZdsExpansionTileState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('initiallyExpanded', initiallyExpanded))
      ..add(DiagnosticsProperty<bool>('maintainState', maintainState))
      ..add(DiagnosticsProperty<EdgeInsets>('contentPadding', contentPadding))
      ..add(DiagnosticsProperty<EdgeInsets>('titlePadding', titlePadding))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onExpanded', onExpanded))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onCollapse', onCollapse))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onCollapsed', onCollapsed))
      ..add(DiagnosticsProperty<bool>('selected', selected))
      ..add(DiagnosticsProperty<bool>('showDivider', showDivider))
      ..add(DiagnosticsProperty<bool>('expandWithIconOnly', expandWithIconOnly))
      ..add(DiagnosticsProperty<bool>('hideExpansionSemantics', hideExpansionSemantics))
      ..add(DiagnosticsProperty<bool>('isExpandable', isExpandable))
      ..add(EnumProperty<ExpansionTileType>('expansionTileType', expansionTileType))
      ..add(ColorProperty('titleColor', titleColor))
      ..add(ObjectFlagProperty<void Function(bool p1)?>.has('onSelected', onSelected));
  }
}

/// State for [ZdsExpansionTile], used to handle the on demand expansion and collapsing of the tile
///
/// ```dart
/// late final expansionKey = GlobalKey<ZdsExpansionTileState>();
/// ```
///
/// See also:
/// * [ZdsExpansionTile]
class ZdsExpansionTileState extends State<ZdsExpansionTile> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  late Animatable<double> _halfTween;
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _halfTween = Tween<double>(begin: 0, end: widget.expansionTileType == ExpansionTileType.selectable ? -0.25 : 0.5);
    _controller = AnimationController(duration: _kExpand, vsync: this);

    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _heightFactor = _controller.drive(_easeInTween);

    _isExpanded = widget.initiallyExpanded;
    _selected = widget.selected;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant ZdsExpansionTile oldWidget) {
    if (oldWidget.selected != widget.selected) {
      _selected = widget.selected;
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Collapses the expanded tile.
  Future<void> collapse() async {
    _isExpanded = false;
    widget.onCollapse?.call();
    await _controller.reverse();
    if (!mounted) return;
    widget.onCollapsed?.call();
    setState(() {
      // Rebuild without widget.children.
    });

    PageStorage.of(context).writeState(context, _isExpanded);
  }

  /// Expands the collapsed tile.
  void expand() {
    _isExpanded = true;
    _controller.forward();

    if (!mounted) return;
    widget.onExpanded?.call();
    setState(() {
      // Rebuild without widget.children.
    });
    PageStorage.of(context).writeState(context, _isExpanded);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Toggles the expansion tile  between collapsed and expanded.
  void toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
        widget.onExpanded?.call();
      } else {
        unawaited(collapse());
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
  }

  /// Function to select and unselect an expansion tile
  void _toggleSelect() {
    setState(() {
      _selected = !_selected;
      widget.onSelected?.call(_selected);
    });
  }

  /// True if the tile is expanded
  bool get isExpanded => _isExpanded;
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;
    final zeta = Zeta.of(context);

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        final ZdsCard? card = context.findAncestorWidgetOfExactType<ZdsCard>();
        final IconButton chevronIcon = IconButton(
          onPressed: toggle,
          icon: RotationTransition(
            turns: _iconTurns,
            child: Icon(
              widget.expansionTileType == ExpansionTileType.regular ? ZdsIcons.chevron_down : ZdsIcons.chevron_right,
              color: zeta.colors.iconDefault,
              size: 24,
            ),
          ),
        );

        final themeData = Theme.of(context);
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Material(
                  color: widget.titleColor,
                  child: Semantics(
                    checked: _selected,
                    child: InkWell(
                      onTap: widget.expandWithIconOnly
                          ? null
                          : widget.expansionTileType == ExpansionTileType.selectable
                              ? _toggleSelect
                              : toggle,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: widget.expansionTileType == ExpansionTileType.selectable
                                ? const EdgeInsets.fromLTRB(8, 4, 20, 4)
                                : widget.titlePadding,
                            child: Row(
                              children: <Widget>[
                                if (widget.expansionTileType == ExpansionTileType.selectable)
                                  Semantics(
                                    onTapHint: _isExpanded
                                        ? ComponentStrings.of(context).get('HIDE', 'Hide')
                                        : ComponentStrings.of(context).get('SHOW', 'Show'),
                                    child: chevronIcon,
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      DefaultTextStyle(
                                        style: safeTextStyle(themeData.textTheme.bodyLarge)
                                            .copyWith(color: zeta.colors.textDefault),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        child: widget.title,
                                      ),
                                      if (widget.subtitle != null) ...<Widget>[
                                        const SizedBox(height: 5),
                                        DefaultTextStyle(
                                          style: themeData.textTheme.bodySmall!.copyWith(
                                            color: zeta.colors.textSubtle,
                                          ),
                                          child: widget.subtitle!,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (widget.isExpandable && widget.expansionTileType == ExpansionTileType.regular)
                                  Semantics(
                                    excludeSemantics: widget.hideExpansionSemantics,
                                    onTapHint: _isExpanded
                                        ? ComponentStrings.of(context).get('HIDE', 'Hide')
                                        : ComponentStrings.of(context).get('SHOW', 'Show'),
                                    child: widget.expandWithIconOnly
                                        ? chevronIcon
                                        : IconTheme(
                                            data: IconThemeData(color: zeta.colors.iconSubtle, size: 24),
                                            child: RotationTransition(
                                              turns: _iconTurns,
                                              child: const Icon(ZdsIcons.chevron_down),
                                            ),
                                          ),
                                  ),
                                if (widget.selected)
                                  IconTheme(
                                    data: IconThemeData(
                                      color: themeData.colorScheme.secondary,
                                      size: 24,
                                    ),
                                    child: const Icon(ZdsIcons.check),
                                  ),
                              ],
                            ),
                          ),
                          if (widget.bottom != null) widget.bottom!,
                        ],
                      ),
                    ),
                  ),
                ),
                ClipRect(
                  child: Align(
                    alignment: Alignment.topLeft,
                    heightFactor: _heightFactor.value,
                    child: child,
                  ),
                ),
              ],
            ),
            if (widget.showDivider)
              Positioned(
                top: -1,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  color: card != null ? zeta.colors.borderSubtle : Colors.transparent,
                ),
              ),
          ],
        );
      },
      child: shouldRemoveChildren || !widget.isExpandable
          ? null
          : Offstage(
              offstage: closed,
              child: TickerMode(
                enabled: !closed,
                child: Padding(
                  padding: widget.contentPadding,
                  child: widget.child,
                ),
              ),
            ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isExpanded', isExpanded));
  }
}
