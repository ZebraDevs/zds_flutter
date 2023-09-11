import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// Variants of [ZdsCard].
enum ZdsCardVariant {
  /// Creates a card with a border on all edges of color [ZdsColors.greySwatch.shade600].
  outlined,

  /// Creates a card with a box shadow around the edges with a radius of 4.
  ///
  ///  Shadow color defaults to [CardTheme.shadowColor] but can be overridden in theme.
  elevated,
}

/// A card used to display grouped information and related actions.
///
/// Cards provide a way to group information together and allow navigating large quantities of data. For example,
/// cards can be used to show information about an employee's shift, including the starting and ending time, the date,
/// and the current status. Cards make parsing information easier and faster than with a traditional table.
///
/// For cards to be effective, an inner hierarchy is necessary. This can be achieved by organizing the information
/// shown in a card with a title, the supporting content, and actions:
///
/// ```dart
/// ZdsCard(
///   child: Column(
///     children: [
///       // Key information like the title can go here so the user understands the card's content in a glance
///       ZdsCardHeader(),
///       // The supporting content of the card (i.e. in a card about a delivery, its status would go here)
///       Text(),
///       // Related actions are placed at the end as they're only useful after the user has processed the rest of the
///       // card's information
///       Row(children:[ZdsButton(), ZdsButton()])
///     ]
///   )
/// )
/// ```
///
/// This widget also integrates [Semantics] through [onTapHint], which is highly recommended to use so Talkback and
/// Voiceover users have an adequate experience.
///
/// See also:
///
///  * [ZdsCardHeader], used to create a title header in a card
///  * [ZdsCardWithActions], a [ZdsCard] variant with an actions/status bar at the bottom.
class ZdsCard extends StatelessWidget {
  /// The card's contents.
  ///
  /// Typically a [Row] or a [Column] so information is organized in a hierarchy from start to end.
  final Widget? child;

  /// The background color of the card.
  ///
  /// Defaults to [ColorScheme.surface]. If [gradient] is specified, this has no effect.
  final Color? backgroundColor;

  /// A function called whenever the user taps on the card.
  ///
  /// If [onTap] is not null, it's highly recommended to use [onTapHint] as well for accessibility purposes.
  final VoidCallback? onTap;

  /// A gradient to apply to the card's background
  ///
  /// If this is specified, [backgroundColor] has no effect.
  final Gradient? gradient;

  /// A String used by [Semantics] to provide a hint of what tapping on this Card will do.
  ///
  /// For more information, look at the [Semantics] class.
  final String? onTapHint;

  /// Empty space to inscribe inside this widget.
  ///
  /// Defaults to EdgeInsets.symmetric(horizontal: 24, vertical 20).
  final EdgeInsets padding;

  /// {@template card-variant}
  /// Whether to use an outlined or elevated card.
  ///
  /// Defaults to [ZdsCardVariant.elevated].
  /// {@endtemplate}
  final ZdsCardVariant variant;

  /// Margin surrounding the outside of the card
  ///
  /// Defaults to [CardTheme.margin].
  final EdgeInsets? margin;

  /// The semantic label applied to the card.
  ///
  /// If not null, the semantics in the card will be excluded.
  final String? semanticLabel;

  /// Creates a card to display information.
  ///
  /// [padding] and [variant] must not be null.
  const ZdsCard({
    super.key,
    this.child,
    this.onTap,
    this.backgroundColor,
    this.gradient,
    this.onTapHint,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    this.variant = ZdsCardVariant.elevated,
    this.margin,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = (Theme.of(context).cardTheme.shape as RoundedRectangleBorder?)?.borderRadius as BorderRadius?;
    final shadowColor = Theme.of(context).cardTheme.shadowColor;
    final container = Container(
      clipBehavior: Clip.antiAlias,
      margin: margin ?? Theme.of(context).cardTheme.margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        gradient: gradient,
        borderRadius: borderRadius,
        border: variant == ZdsCardVariant.outlined
            ? Border.all(
                color: ZdsColors.greySwatch(
                  context,
                )[Theme.of(context).colorScheme.brightness == Brightness.dark ? 1000 : 600]!,
              )
            : null,
        boxShadow: [
          if (shadowColor != null && variant == ZdsCardVariant.elevated) BoxShadow(color: shadowColor, blurRadius: 4),
        ],
      ),
      child: Material(
        color: ZdsColors.transparent,
        child: Semantics(
          onTapHint: onTapHint,
          child: InkWell(
            splashColor: ZdsColors.splashColor,
            hoverColor: Colors.transparent,
            onTap: onTap ?? () {},
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );

    if (semanticLabel != null) {
      return Semantics(
        label: semanticLabel,
        onTapHint: onTapHint,
        onTap: onTap,
        excludeSemantics: true,
        child: container,
      );
    } else {
      return container;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<Gradient?>('gradient', gradient));
    properties.add(StringProperty('onTapHint', onTapHint));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(EnumProperty<ZdsCardVariant>('variant', variant));
    properties.add(DiagnosticsProperty<EdgeInsets?>('margin', margin));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }
}
