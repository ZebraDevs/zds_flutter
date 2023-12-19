import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

import '../../../../zds_flutter.dart';

/// An icon button with a popover.
///
/// ```dart
///ZdsPopOverIconButton(
///   icon: const Icon(ZdsIcons.info),
///   popOverBuilder: (context) {
///     return const Text('Popover text!');
///   },
/// ),
/// ```
class ZdsPopOverIconButton extends StatelessWidget {
  /// Constructs an icon button with a popover.
  const ZdsPopOverIconButton({
    required this.icon,
    required this.popOverBuilder,
    super.key,
    this.onDismissed,
    this.iconSize = 24.0,
    this.visualDensity,
    this.padding = const EdgeInsets.all(8),
    this.alignment = Alignment.center,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.mouseCursor = SystemMouseCursors.click,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.buttonConstraints,
    this.popOverConstraints,
    this.backgroundColor,
    this.contentDyOffset = 0.0,
    this.barrierLabel,
  }) : assert(splashRadius == null || splashRadius > 0, 'Splash radius must be greater than 0');

  /// Icon for the icon button.
  final Icon icon;

  /// A [WidgetBuilder] that builds the content of the popover.
  ///
  /// This will be wrapped in a popover of Zds style.
  ///
  /// Usually a function that returns a [Text].
  final WidgetBuilder popOverBuilder;

  /// Callback function called when popover is dismissed.
  final void Function(dynamic)? onDismissed;

  /// Size of the [IconButton].
  ///
  /// Defaults to 24.
  final double iconSize;

  /// Defines the visual density of the [IconButton].
  final VisualDensity? visualDensity;

  /// Defines the inset padding of the [IconButton].
  final EdgeInsetsGeometry padding;

  /// Defines the  of the [IconButton].
  final AlignmentGeometry alignment;

  /// Defines the splashRadius of the [IconButton].
  final double? splashRadius;

  /// Defines the focusColor of the [IconButton].
  final Color? focusColor;

  /// Defines the hoverColor of the [IconButton].
  final Color? hoverColor;

  /// Defines the color of the [IconButton].
  final Color? color;

  /// Defines the splashColor of the [IconButton].
  final Color? splashColor;

  /// Defines the highlightColor of the [IconButton].
  final Color? highlightColor;

  /// Defines the disabledColor of the [IconButton].
  final Color? disabledColor;

  /// Defines the mouseCursor of the [IconButton].
  final MouseCursor mouseCursor;

  /// Defines the focusNode of the [IconButton].
  final FocusNode? focusNode;

  /// Defines the autofocus of the [IconButton].
  final bool autofocus;

  /// Defines the enableFeedback of the [IconButton].
  final bool enableFeedback;

  /// Defines the buttonConstraints of the [IconButton].
  final BoxConstraints? buttonConstraints;

  /// Defines the constraints for the child of the popover.
  ///
  /// Defaults to `BoxConstraints(maxWidth: size.width * 0.94)`
  final BoxConstraints? popOverConstraints;

  /// Background color of the popover.
  ///
  /// Defaults to [ColorScheme.surface].
  final Color? backgroundColor;

  /// Defines the vertical offset of the popover from the icon.
  final double contentDyOffset;

  /// Semantic label used for a dismissible barrier.
  final String? barrierLabel;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final BoxConstraints defaultPopOverConstraints = BoxConstraints(maxWidth: size.width * 0.94);

    Widget popOverWrapper = popOverBuilder(context);

    if (popOverConstraints?.minHeight == null || popOverConstraints?.minHeight == 0) {
      popOverWrapper = IntrinsicHeight(
        child: popOverBuilder(context),
      );
    }

    return IconButton(
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: padding,
      alignment: alignment,
      splashRadius: splashRadius,
      color: color,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      disabledColor: disabledColor,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      enableFeedback: enableFeedback,
      constraints: buttonConstraints,
      onPressed: () async {
        final dynamic result = await showZdsPopOver<dynamic>(
          context: context,
          backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
          contentDyOffset: contentDyOffset,
          barrierLabel: barrierLabel,
          constraints: popOverConstraints ?? defaultPopOverConstraints,
          builder: (_) {
            return popOverWrapper;
          },
        );
        onDismissed?.call(result);
      },
      icon: icon,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<WidgetBuilder>.has('popOverBuilder', popOverBuilder))
      ..add(ObjectFlagProperty<void Function(dynamic p1)?>.has('onDismissed', onDismissed))
      ..add(DoubleProperty('iconSize', iconSize))
      ..add(DiagnosticsProperty<VisualDensity?>('visualDensity', visualDensity))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding))
      ..add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment))
      ..add(DoubleProperty('splashRadius', splashRadius))
      ..add(ColorProperty('focusColor', focusColor))
      ..add(ColorProperty('hoverColor', hoverColor))
      ..add(ColorProperty('color', color))
      ..add(ColorProperty('splashColor', splashColor))
      ..add(ColorProperty('highlightColor', highlightColor))
      ..add(ColorProperty('disabledColor', disabledColor))
      ..add(DiagnosticsProperty<MouseCursor>('mouseCursor', mouseCursor))
      ..add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode))
      ..add(DiagnosticsProperty<bool>('autofocus', autofocus))
      ..add(DiagnosticsProperty<bool>('enableFeedback', enableFeedback))
      ..add(DiagnosticsProperty<BoxConstraints?>('buttonConstraints', buttonConstraints))
      ..add(DiagnosticsProperty<BoxConstraints?>('popOverConstraints', popOverConstraints))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('contentDyOffset', contentDyOffset))
      ..add(StringProperty('barrierLabel', barrierLabel));
  }
}

/// Future that creates a popover.
///
/// * [context] (required) The context of the popover.
/// * [builder] (required) A [WidgetBuilder] that builds the content of the popover. This will be wrapped in a popover of Zds style. Usually a function that returns a [Text].
/// * [backgroundColor] The background color of the popover.  Defaults to [ColorScheme.surface].
/// * [radius] Radius of the popover's body. Defaults to 6.
/// * [contentDyOffset] The vertical offset of the popover from the icon.
/// * [constraints] Defines the constraints for the child of the popover.
/// * [onPop] VoidCallback function that is called when the popover is popped.
/// * [barrierLabel] Semantic label used for a dismissible barrier.
Future<T?> showZdsPopOver<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double radius = 6,
  double contentDyOffset = 0.0,
  Duration transitionDuration = const Duration(milliseconds: 100),
  BoxConstraints? constraints,
  VoidCallback? onPop,
  String? barrierLabel,
}) {
  final Offset parentPosition = context.widgetGlobalPosition;
  final bool parentIsAtTopHandSide = (parentPosition.dy + contentDyOffset) < MediaQuery.of(context).size.height / 2;
  final PopoverDirection direction = parentIsAtTopHandSide ? PopoverDirection.bottom : PopoverDirection.top;

  return showPopover<T>(
    context: context,
    transitionDuration: transitionDuration,
    bodyBuilder: builder,
    onPop: onPop,
    direction: direction,
    arrowHeight: 10,
    arrowWidth: 25,
    radius: radius,
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
    barrierColor: Colors.transparent,
    contentDyOffset: contentDyOffset,
    constraints: constraints,
    barrierLabel: barrierLabel,
  );
}
