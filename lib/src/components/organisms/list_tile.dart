import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/theme.dart';
import '../../utils/tools/utils.dart';
import '../atoms/card.dart';
import '../atoms/conditional_wrapper.dart';
import '../molecules/list.dart';
import '../molecules/list_tile_wrapper.dart';
import 'list_group.dart';

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
    this.shrinkWrap = true,
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
  /// [TextStyle.color]. The [TextStyle.color] is [ColorScheme.onSurface].
  final Widget? subtitle;

  /// A widget to display after the title.
  final Widget? trailing;

  /// A widget to display below the content of the tile.
  ///
  /// Typically a divider.
  final Widget? bottom;

  /// Whether the tiles are closely packed together or separated
  ///
  /// Defaults to true
  ///
  /// Is overridden to true if the tile is within a [ZdsListGroup].
  final bool shrinkWrap;

  /// Called when the user taps this list tile.
  final VoidCallback? onTap;

  /// Empty space to inscribe within the tile, surrounding the contents.
  ///
  /// Defaults to [ZdsListTileTheme.contentPadding].
  final EdgeInsets? contentPadding;

  /// The background color of the tile.
  ///
  /// Defaults to [ColorScheme.surface], or [Colors.transparent] if with a [ZdsListGroup].
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

  bool _isFormField(Widget? widget) => widget is TextField || widget is TextFormField;

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
    final themeData = Theme.of(context);
    final EdgeInsets padding = contentPadding ?? kZdsListTileTheme.contentPadding;
    final TextStyle? titleStyle = themeData.textTheme.bodyMedium;
    final zetaColors = Zeta.of(context).colors;
    final Color subtitleColor = zetaColors.textSubtle;
    final EdgeInsets insets = _resolveInsets(padding);
    final Color effectiveBackground = backgroundColor ??
        (context.findAncestorWidgetOfExactType<ZdsListGroup>() != null
            ? Colors.transparent
            : themeData.colorScheme.surface);

    final shouldShrink = shrinkWrap ||
        (context.findAncestorWidgetOfExactType<ZdsListGroup>() != null ||
            context.findAncestorWidgetOfExactType<ZdsListTileWrapper>() != null);

    final DefaultTextStyle? trailingWrapper = trailing != null
        ? DefaultTextStyle(
            style: safeTextStyle(titleStyle).copyWith(color: subtitleColor),
            child: IconTheme(
              data: themeData.iconTheme.copyWith(
                size: kZdsListTileTheme.iconSize,
                color: themeData.colorScheme.onSurface,
              ),
              child: trailing!,
            ),
          )
        : null;

    final IconTheme? leadingWrapper = leading != null
        ? IconTheme(
            data:
                themeData.iconTheme.copyWith(size: kZdsListTileTheme.iconSize, color: themeData.colorScheme.secondary),
            child: leading!,
          )
        : null;

    Widget tile = Container(
      padding: insets,
      constraints: const BoxConstraints(minHeight: 40),
      alignment: Alignment.center,
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
                  if (title != null) DefaultTextStyle(style: safeTextStyle(titleStyle), child: title!),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: 5),
                    DefaultTextStyle(
                      style: safeTextStyle(themeData.textTheme.bodyMedium).copyWith(color: subtitleColor),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (trailingWrapper != null)
            ZdsConditionalWrapper(
              condition: _isFormField(trailing),
              wrapperBuilder: (Widget child) {
                return Theme(
                  data: themeData.copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      contentPadding: EdgeInsets.symmetric(horizontal: 4),
                      border: InputBorder.none,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 12),
                    width: MediaQuery.of(context).size.width / 2,
                    child: child,
                  ),
                );
              },
              child: trailingWrapper,
            ),
        ],
      ),
    );

    tile = InkWell(
      onTap: onTap,
      splashColor: zetaColors.surfaceSelected,
      hoverColor: zetaColors.surfaceHovered,
      child: (bottom != null)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                tile,
                bottom!,
              ],
            )
          : tile,
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

    if (!shouldShrink) {
      tile = Padding(
        padding: EdgeInsets.symmetric(vertical: kZdsListTileTheme.tileMargin),
        child: ZdsCard(
          variant: cardVariant ?? ZdsCardVariant.elevated,
          padding: EdgeInsets.zero,
          margin: margin,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: kZdsListTileTheme.tileMargin),
            child: tile,
          ),
        ),
      );
    }

    return Material(color: effectiveBackground, child: tile);
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
