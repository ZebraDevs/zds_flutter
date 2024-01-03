import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

/// A widget that creates a slidable list tile, which can be slid right-to-left to reveal further actions.
/// Takes a [child] which can be any widget, although a [Row] is recommended to use like so:
///  ```dart
/// ZdsSlidableListTile(
///   child: Row(
///     children: [
///       LeadingWidget(),
///       Spacer(),
///       TrailingWidget()
///     ],
///   ),
/// );
/// ```
///
/// Although this widget has predefined styling, it can be adjusted with [backgroundColor] and [slideButtonWidth].
/// This is recommended for example to indicate state change.
///
/// It is also possible that the actions text will not fit within the default action width and will be ellipsized, in
/// which case you can increase [slideButtonWidth]. [slideButtonWidth] * [actions].length must not exceed [width].
///
/// If we don't want the slide actions to be shown (i.e. the tile is in a selected state), then [slideEnabled]
/// must be set to false. This will not allow the user to slide to see more actions, but they will still be able to
/// interact with the tile's main contents. To disable the user interacting with the tile, you can set the [onTap] to
/// null.
///
/// This widget's actions are defined through [ZdsSlidableAction].
class ZdsSlidableListTile extends StatelessWidget {
  /// A tile that can be slid to reveal further actions.
  ///
  /// [width], [child], and [actions] are required and can't be null.
  /// [slideButtonWidth] and [slideEnabled] can't be null.
  const ZdsSlidableListTile({
    required this.width,
    required this.child,
    super.key,
    this.actions,
    this.leadingActions,
    this.backgroundColor,
    this.slideButtonWidth = 100,
    this.minHeight = 80,
    this.onTap,
    this.slideEnabled = true,
    this.semanticDescription,
  }) : assert(actions == null || slideButtonWidth * actions.length <= width, '');

  /// The tile's main content. Usually a [Row]
  final Widget child;

  /// The length of the tile. On vertical displays this usually is `MediaQuery.of(context).size.width`.
  /// Must exceed or be equal to [slideButtonWidth] * [actions].length.
  final double width;

  /// The actions that will be revealed when the user swipes left on the tile. Must not be empty for the slidable action to occur.
  final List<ZdsSlidableAction>? actions;

  /// The actions that will be revealed when the user swipes right on the tile. Must not be empty for the slidable action to occur.
  final List<ZdsSlidableAction>? leadingActions;

  /// The background color of the tile's main content. Defaults to [ColorScheme.surface]
  final Color? backgroundColor;

  /// How wide each action button is. Text that does not fit this width will be ellipsized.
  final double slideButtonWidth;

  /// Will be called whenever the user taps on the tile's main content.
  final VoidCallback? onTap;

  /// Whether to show the slide actions.
  final bool slideEnabled;

  /// Minimum height of the list tile.
  ///
  /// Defaults to 80.
  final double minHeight;

  /// Description used as semantic label for the tile.
  ///
  /// Typically will contain all the text displayed on the card UI.
  final String? semanticDescription;

  @override
  Widget build(BuildContext context) {
    final Map<CustomSemanticsAction, VoidCallback> semanticActions = <CustomSemanticsAction, VoidCallback>{};

    for (final ZdsSlidableAction action in <ZdsSlidableAction>[...?actions, ...?leadingActions]) {
      semanticActions[CustomSemanticsAction(label: action.label)] = () {
        action.onPressed!(context);
      };
    }

    return Semantics(
      label: semanticDescription,
      customSemanticsActions: semanticActions,
      excludeSemantics: semanticDescription != null,
      child: Slidable(
        enabled: slideEnabled,
        startActionPane: leadingActions != null && leadingActions!.isNotEmpty
            ? ActionPane(
                motion: const DrawerMotion(),
                extentRatio: (slideButtonWidth * leadingActions!.length) / width,
                children: <Widget>[
                  for (final ZdsSlidableAction action in leadingActions!) _ActionBuilder(action: action),
                ],
              )
            : null,
        endActionPane: actions != null && actions!.isNotEmpty
            ? ActionPane(
                motion: const DrawerMotion(),
                extentRatio: (slideButtonWidth * (actions!.length)) / width,
                children: <Widget>[for (final ZdsSlidableAction action in actions!) _ActionBuilder(action: action)],
              )
            : null,
        child: Card(
          shape: const ContinuousRectangleBorder(),
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: onTap,
            child: Container(
              constraints: BoxConstraints(minHeight: minHeight),
              width: MediaQuery.of(context).size.width,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('width', width))
      ..add(IterableProperty<ZdsSlidableAction>('actions', actions))
      ..add(IterableProperty<ZdsSlidableAction>('leadingActions', leadingActions))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('slideButtonWidth', slideButtonWidth))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('slideEnabled', slideEnabled))
      ..add(DoubleProperty('minHeight', minHeight))
      ..add(StringProperty('semanticDescription', semanticDescription));
  }
}

class _ActionBuilder extends StatefulWidget {
  const _ActionBuilder({required this.action});
  final ZdsSlidableAction action;

  @override
  State<_ActionBuilder> createState() => _ActionBuilderState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ZdsSlidableAction>('action', action));
  }
}

class _ActionBuilderState extends State<_ActionBuilder> {
  final GlobalKey<State<StatefulWidget>> _key = GlobalKey();

  Size _size = Size.zero;
  Size get size => _size;
  set size(Size size) {
    if (_size == size) return;
    setState(() {
      _size = size;
    });
  }

  @override
  void initState() {
    super.initState();
    unawaited(
      WidgetsBinding.instance.endOfFrame.then(
        (_) => size = _key.currentContext?.size ?? Size.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return FlutterSlidableAction(
      key: _key,
      onPressed: widget.action.onPressed,
      label: size.height < 60 && widget.action.icon != null ? null : widget.action.label,
      icon: widget.action.icon,
      backgroundColor: widget.action.backgroundColor ?? themeData.colorScheme.background,
      foregroundColor: widget.action.foregroundColor ?? themeData.colorScheme.onBackground,
      autoClose: widget.action.autoclose,
      spacing: 16,
      padding: EdgeInsets.zero,
      textOverflow: widget.action.textOverflow,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('size', size));
  }
}

/// Defines an action that will be shown when sliding on a ZdsSlidableListTile.
class ZdsSlidableAction {
  /// Defines an action that will be shown when sliding on a ZdsSlidableListTile.
  /// [label] must not be empty.
  /// [backgroundColor], [foregroundColor], and [autoclose] must not be null
  ZdsSlidableAction({
    required this.label,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.autoclose = true,
    this.padding = EdgeInsets.zero,
    this.textOverflow,
  }) : assert(label.isNotEmpty, 'Label must have content as it acts as the semantic button description');

  /// Function called on press of the widget.
  final void Function(BuildContext)? onPressed;

  /// The text that will be shown above the icon. It can't be empty.
  final String label;

  /// An optional icon that will be shown below the label.
  final IconData? icon;

  /// Background color of the widget.
  ///
  /// Should be visually different to the background color of the parent [ZdsSlidableListTile] and any other [ZdsSlidableAction].
  ///
  /// If null, uses default background color.
  final Color? backgroundColor;

  /// The label and icon color.
  ///
  /// If null, uses default text color.
  final Color? foregroundColor;

  /// Whether to automatically close the actions after tapping on this action. Defaults to true.
  final bool autoclose;

  ///{@macro slidable.actions.padding}
  final EdgeInsets padding;

  /// Optional parameter to handle overflowing text
  ///
  /// if null, the default value is [TextOverflow.ellipsis]
  final TextOverflow? textOverflow;
}

// Modified version of SlidableAction from flutter_slidable package

/// Signature for [CustomSlidableAction.onPressed].
typedef SlidableActionCallback = void Function(BuildContext context);

const int _kFlex = 1;
const Color _kBackgroundColor = Colors.white;
const bool _kAutoClose = true;

/// Represents an action of an [ActionPane].
class CustomSlidableAction extends StatelessWidget {
  /// Creates a [CustomSlidableAction].
  ///
  /// The [flex], [backgroundColor], [autoClose] and [child] arguments must not
  /// be null.
  ///
  /// The [flex] argument must also be greater than 0.
  const CustomSlidableAction({
    required this.onPressed,
    required this.child,
    this.flex = _kFlex,
    this.backgroundColor = _kBackgroundColor,
    this.foregroundColor,
    this.autoClose = _kAutoClose,
    this.borderRadius = BorderRadius.zero,
    this.padding,
    super.key,
  });

  /// {@template slidable.actions.flex}
  /// The flex factor to use for this child.
  ///
  /// The amount of space the child's can occupy in the main axis is
  /// determined by dividing the free space according to the flex factors of the
  /// other [CustomSlidableAction]s.
  /// {@endtemplate}
  final int flex;

  /// {@template slidable.actions.backgroundColor}
  /// The background color of this action.
  ///
  /// Defaults to [Colors.white].
  /// {@endtemplate}
  final Color backgroundColor;

  /// {@template slidable.actions.foregroundColor}
  /// The foreground color of this action.
  ///
  /// Defaults to [Colors.black] if the background brightness is [Brightness.light],
  /// or to [Colors.white] if background brightness is [Brightness.dark].
  /// {@endtemplate}
  final Color? foregroundColor;

  /// {@template slidable.actions.autoClose}
  /// Whether the enclosing [Slidable] will be closed after [onPressed]
  /// occurred.
  /// {@endtemplate}
  final bool autoClose;

  /// {@template slidable.actions.onPressed}
  /// Called when the action is tapped or otherwise activated.
  ///
  /// If this callback is null, then the action will be disabled.
  /// {@endtemplate}
  final SlidableActionCallback? onPressed;

  /// {@template slidable.actions.borderRadius}
  /// The borderRadius of this action
  ///
  /// Defaults to [BorderRadius.zero].
  /// {@endtemplate}
  final BorderRadius borderRadius;

  /// {@template slidable.actions.padding}
  /// The padding of the OutlinedButton
  /// {@endtemplate}
  final EdgeInsets? padding;

  /// Typically the action's icon or label.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Color effectiveForegroundColor = foregroundColor ??
        (ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.light ? Colors.black : Colors.white);

    return Expanded(
      flex: flex,
      child: SizedBox.expand(
        child: OutlinedButton(
          onPressed: () => _handleTap(context),
          style: OutlinedButton.styleFrom(
            padding: padding,
            backgroundColor: backgroundColor,
            foregroundColor: effectiveForegroundColor,
            disabledForegroundColor: effectiveForegroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            side: BorderSide.none,
          ),
          child: child,
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    onPressed?.call(context);
    if (autoClose) {
      unawaited(Slidable.of(context)?.close());
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('flex', flex))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ColorProperty('foregroundColor', foregroundColor))
      ..add(DiagnosticsProperty<bool>('autoClose', autoClose))
      ..add(ObjectFlagProperty<SlidableActionCallback?>.has('onPressed', onPressed))
      ..add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius))
      ..add(DiagnosticsProperty<EdgeInsets?>('padding', padding));
  }
}

/// An action for [Slidable] which can show an icon, a label, or both.
class FlutterSlidableAction extends StatelessWidget {
  /// The [flex], [backgroundColor], [autoClose] and [spacing] arguments
  /// must not be null.
  ///
  /// You must set either an [icon] or a [label].
  ///
  /// The [flex] argument must also be greater than 0.
  const FlutterSlidableAction({
    required this.onPressed,
    this.flex = _kFlex,
    this.backgroundColor = _kBackgroundColor,
    this.foregroundColor,
    this.autoClose = _kAutoClose,
    this.icon,
    this.spacing = 4,
    this.label,
    this.borderRadius = BorderRadius.zero,
    this.padding,
    this.textOverflow,
    super.key,
  });

  /// {@macro slidable.actions.flex}
  final int flex;

  /// {@macro slidable.actions.backgroundColor}
  final Color backgroundColor;

  /// {@macro slidable.actions.foregroundColor}
  final Color? foregroundColor;

  /// {@macro slidable.actions.autoClose}
  final bool autoClose;

  /// {@macro slidable.actions.onPressed}
  final SlidableActionCallback? onPressed;

  /// An icon to display above the [label].
  final IconData? icon;

  /// The space between [icon] and [label] if both set.
  ///
  /// Defaults to 4.
  final double spacing;

  /// A label to display below the [icon].
  final String? label;

  /// Padding of the OutlinedButton
  final BorderRadius borderRadius;

  /// Padding of the OutlinedButton
  final EdgeInsets? padding;

  /// Optional parameter to handle overflowing text
  ///
  /// if null, the default value is [TextOverflow.ellipsis]
  final TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    if (icon != null) {
      children.add(
        Icon(icon),
      );
    }

    if (label != null) {
      if (children.isNotEmpty) {
        children.add(
          SizedBox(height: spacing),
        );
      }

      children.add(
        Text(
          label!,
          overflow: textOverflow ?? TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      );
    }

    final Widget child = children.length == 1
        ? children.first
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ...children.map(
                (Widget child) => Flexible(
                  child: child,
                ),
              ),
            ],
          );

    return CustomSlidableAction(
      borderRadius: borderRadius,
      padding: padding,
      onPressed: onPressed,
      autoClose: autoClose,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      flex: flex,
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('flex', flex))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ColorProperty('foregroundColor', foregroundColor))
      ..add(DiagnosticsProperty<bool>('autoClose', autoClose))
      ..add(ObjectFlagProperty<SlidableActionCallback?>.has('onPressed', onPressed))
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(DoubleProperty('spacing', spacing))
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius))
      ..add(DiagnosticsProperty<EdgeInsets?>('padding', padding))
      ..add(EnumProperty<TextOverflow?>('textOverflow', textOverflow));
  }
}
