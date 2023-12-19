import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// Variants of [ZdsCard].
enum ZdsCardVariant {
  /// Creates a card with a border on all edges of color [ZetaColors.borderDefault].
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

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;
    final themeData = Theme.of(context);

    // Regular border radius
    BorderRadius borderRadius = BorderRadius.circular(kZdsCardRadius);

    // Check if the card shape is Rounded Rectangle and accordingly set its borderRadius
    if (themeData.cardTheme.shape != null && themeData.cardTheme.shape is RoundedRectangleBorder) {
      final cardShape = themeData.cardTheme.shape as RoundedRectangleBorder?;
      if (cardShape != null && cardShape.borderRadius is BorderRadius) {
        borderRadius = cardShape.borderRadius as BorderRadius;
      }
    }

    final shadowColor = themeData.cardTheme.shadowColor;

    final Container container = Container(
      clipBehavior: Clip.antiAlias,
      margin: margin ?? themeData.cardTheme.margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? themeData.colorScheme.surface,
        gradient: gradient,
        borderRadius: borderRadius,
        border: variant == ZdsCardVariant.outlined ? Border.all(color: zetaColors.borderDefault) : null,
        boxShadow: <BoxShadow>[
          if (shadowColor != null && variant == ZdsCardVariant.elevated) ...[
            BoxShadow(blurRadius: 1, color: shadowColor),
          ],
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Semantics(
          onTapHint: onTapHint,
          child: ZdsConditionalWrapper(
            condition: onTap != null,
            child: Padding(padding: padding, child: child),
            wrapperBuilder: (child) {
              return InkWell(
                splashColor: zetaColors.surfaceSelected,
                hoverColor: zetaColors.surfaceSelectedHovered,
                onTap: onTap,
                child: child,
              );
            },
          ),
        ),
      ),
    );

    return ZdsConditionalWrapper(
      condition: semanticLabel != null,
      child: container,
      wrapperBuilder: (Widget child) {
        return Semantics(
          label: semanticLabel,
          onTapHint: onTapHint,
          onTap: onTap,
          excludeSemantics: true,
          child: child,
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<Gradient?>('gradient', gradient))
      ..add(StringProperty('onTapHint', onTapHint))
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding))
      ..add(EnumProperty<ZdsCardVariant>('variant', variant))
      ..add(DiagnosticsProperty<EdgeInsets?>('margin', margin))
      ..add(StringProperty('semanticLabel', semanticLabel));
  }
}
