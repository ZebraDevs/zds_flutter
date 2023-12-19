import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../../../zds_flutter.dart';

/// List tile with Zds styling.
///
/// Many parameters have similar functionality to those in [ListTile].
///
/// See also:
///
///  * [ListTile]
///  * [ZdsList]
///  * [ZdsListGroup].
class ZdsListTile extends StatelessWidget {
  /// Constructs a [ZdsListTile].
  const ZdsListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.bottom,
    this.onTap,
    this.shrinkWrap,
    this.contentPadding,
    this.backgroundColor,
    this.margin,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.cardVariant = ZdsCardVariant.elevated,
    this.semanticLabel,
  });

  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget? leading;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use [Text.maxLines].
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  ///
  /// The subtitle's default [TextStyle] depends on [TextTheme.bodyMedium] except
  /// [TextStyle.color]. The [TextStyle.color] is [ColorScheme.onBackground].
  final Widget? subtitle;

  /// A widget to display after the title.
  final Widget? trailing;

  /// A widget to display below the content of the tile.
  ///
  /// Typically a divider.
  final Widget? bottom;

  /// Whether the tiles are closely packed together or separated
  ///
  /// Defaults to false
  ///
  /// Is overridden to true if the tile is within a [ZdsListGroup].
  final bool? shrinkWrap;

  /// Called when the user taps this list tile.
  final VoidCallback? onTap;

  /// Empty space to inscribe within the tile, surrounding the contents.
  ///
  /// Defaults to [ZdsListTileTheme.contentPadding].
  final EdgeInsets? contentPadding;

  /// The background color of the tile.
  ///
  /// Defaults to [ColorScheme.background], or [Colors.transparent] if with a [ZdsListGroup].
  final Color? backgroundColor;

  /// The crossAxisAlignment of the tile's main Row.
  ///
  /// Defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment crossAxisAlignment;

  /// The margin for the tile.
  final EdgeInsets? margin;

  /// {@macro card-variant}
  final ZdsCardVariant? cardVariant;

  /// for semantics of list tile
  final String? semanticLabel;

  bool _isAction(Widget? widget) => widget is IconButton || widget is Switch;

  EdgeInsets _resolveInsets(EdgeInsets padding) {
    return EdgeInsets.only(
      left: _isAction(leading) ? 12 : padding.left,
      right: trailing == null
          ? 0
          : trailing is Text
              ? padding.right
              : _isAction(trailing)
                  ? 6
                  : 18,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ZdsListTileTheme theme = Theme.of(context).zdsListTileThemeData;
    final EdgeInsets padding = contentPadding ?? theme.contentPadding;

    final IconTheme? leadingWrapper = leading != null
        ? IconTheme(
            data: Theme.of(context)
                .iconTheme
                .copyWith(size: theme.iconSize, color: Theme.of(context).colorScheme.secondary),
            child: leading!,
          )
        : null;
    final TextStyle titleStyle = Theme.of(context).textTheme.bodyMedium!;
    final Color subtitleColor = theme.subtitleColor;
    final DefaultTextStyle? trailingWrapper = trailing != null
        ? DefaultTextStyle(
            style: titleStyle.copyWith(color: subtitleColor),
            child: IconTheme(
              data: Theme.of(context).iconTheme.copyWith(
                    size: theme.iconSize,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              child: trailing!,
            ),
          )
        : null;

    final EdgeInsets insets = _resolveInsets(padding);

    final Color setBackgroundColor = backgroundColor ??
        (context.findAncestorWidgetOfExactType<ZdsListGroup>() != null
            ? ZdsColors.transparent
            : Theme.of(context).colorScheme.surface);
    Widget tile = Container(
      padding: insets,
      constraints: const BoxConstraints(minHeight: 40),
      alignment: Alignment.center,
      color: setBackgroundColor,
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
          if (leadingWrapper != null) ...<Widget>[
            leadingWrapper,
            SizedBox(width: _isAction(leading) ? 2 : 6),
          ],
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: padding.top, bottom: padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (title != null) DefaultTextStyle(style: titleStyle, child: title!),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: 5),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: subtitleColor),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (trailing != null)
            Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                  border: InputBorder.none,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 12),
                width:
                    trailing is TextField || trailing is TextFormField ? MediaQuery.of(context).size.width / 2 : null,
                child: trailingWrapper,
              ),
            ),
        ],
      ),
    );

    tile = InkWell(
      onTap: onTap,
      splashColor: ZdsColors.splashColor,
      hoverColor: ZetaColors.of(context).isDarkMode ? ZetaColors.of(context).warm.shade10 : ZdsColors.hoverColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          tile,
          if (bottom != null) bottom!,
        ],
      ),
    );

    if (semanticLabel != null) {
      tile = Semantics(
        button: onTap != null,
        label: semanticLabel,
        excludeSemantics: true,
        onTap: onTap,
        child: tile,
      );
    }

    if (!(shrinkWrap ?? true)) {
      tile = Padding(
        padding: EdgeInsets.symmetric(vertical: theme.tileMargin),
        child: ZdsCard(
          variant: cardVariant ?? ZdsCardVariant.elevated,
          padding: EdgeInsets.zero,
          margin: margin,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: theme.tileMargin),
            child: tile,
          ),
        ),
      );
    }
    return Material(color: ZdsColors.transparent, child: tile);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool?>('shrinkWrap', shrinkWrap))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<EdgeInsets?>('contentPadding', contentPadding))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(EnumProperty<CrossAxisAlignment>('crossAxisAlignment', crossAxisAlignment))
      ..add(DiagnosticsProperty<EdgeInsets?>('margin', margin))
      ..add(EnumProperty<ZdsCardVariant?>('cardVariant', cardVariant))
      ..add(StringProperty('semanticLabel', semanticLabel));
  }
}
