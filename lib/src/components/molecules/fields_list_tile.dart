import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/tools/modifiers.dart';
import '../../utils/tools/utils.dart';
import '../atoms/card.dart';
import '../organisms/properties_list.dart';

/// A tile showing a list of properties with their respective values.
///
/// This component can be used instead of a table to show a lot of data at once in an easy to scan format.
///
/// ```dart
/// ZdsFieldsListTile(
///   title: const Text('Project Title'),
///   fields: const [
///     TileField(
///       start: Text('Start/End'),
///       end: Text('07/05/2021 - 07/05/2021'),
///     ),
///     TileField(
///       start: Text('Approval Date'),
///       end: Text('07/06/2021 16:45 PST'),
///     ),
///   ],
///   data: ProjectDataObject(),
///   onTap: (data) => manageProjectDataObject(),
/// ),
/// ```
///
/// See also:
///
///  * [ZdsPropertiesList], another way to show table-like data.
///  * [TileField], which defines the fields.
class ZdsFieldsListTile<T> extends StatelessWidget {
  /// Creates a tile showing a list of properties with their respective values.

  const ZdsFieldsListTile({
    super.key,
    this.title,
    this.fields,
    this.fieldsStartTextStyle,
    this.fieldsEndTextStyle,
    this.data,
    this.footnote,
    this.onTap,
    this.shrink = true,
    this.startFieldFlexFactor,
    this.cardPadding = const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
  });

  /// The title, shown at the top of this tile.
  ///
  /// Typically a [Text].
  final Widget? title;

  /// A list of pairs of data.
  ///
  /// Typically, [TileField.start] is that pair's title, while [TileField.end] is that pair's value.
  final List<TileField>? fields;

  /// The textStyle used for the starting elements of each field.
  ///
  /// Defaults to [TextTheme.titleSmall] with [ZetaColorSwatch.text] color.
  final TextStyle? fieldsStartTextStyle;

  /// The textStyle used for the end elements of each field.
  ///
  /// Defaults to [TextTheme.bodyMedium].
  final TextStyle? fieldsEndTextStyle;

  /// Data called in [onTap] argument.
  final T? data;

  /// The additional information, shown at the bottom of this tile.
  ///
  /// Typically a [Text].
  final Widget? footnote;

  /// The function to call whenever the user taps on this tile.
  ///
  /// [data] is passed as an argument.
  final void Function(T?)? onTap;

  /// Whether the fields are closely packed together or separated with more space.
  ///
  /// Defaults to true.
  final bool shrink;

  /// Determines how much space the start field should take up in the [TileField] row.
  ///
  /// Default is 0.
  final int? startFieldFlexFactor;

  /// The card's internal padding.
  ///
  /// Defaults to EdgeInsets.symmetric(horizontal: 14, vertical: 18).
  final EdgeInsets cardPadding;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return ZdsCard(
      padding: cardPadding,
      onTap: onTap != null ? () => onTap!.call(data) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (title != null)
            DefaultTextStyle(
              style: themeData.textTheme.bodyLarge!,
              child: title!,
            ).space(),
          if (fields != null)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, int index) => buildDetailRow(
                context: context,
                field: fields![index],
                fieldsStartDefaultStyle: fieldsStartTextStyle,
                fieldsEndDefaultStyle: fieldsEndTextStyle,
                startFieldFlexFactor: startFieldFlexFactor,
              ),
              separatorBuilder: (_, int index) =>
                  SizedBox(height: fields?[index].start != null && fields?[index].end != null ? (shrink ? 10 : 18) : 0),
              itemCount: fields!.length,
            ),
          if (footnote != null)
            Column(
              children: <Widget>[
                const SizedBox(height: 8),
                DefaultTextStyle(
                  style: safeTextStyle(themeData.textTheme.bodyMedium).copyWith(
                    color: Zeta.of(context).colors.textDisabled,
                  ),
                  child: footnote!,
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<TileField>('fields', fields))
      ..add(DiagnosticsProperty<TextStyle?>('fieldsStartTextStyle', fieldsStartTextStyle))
      ..add(DiagnosticsProperty<TextStyle?>('fieldsEndTextStyle', fieldsEndTextStyle))
      ..add(DiagnosticsProperty<T?>('data', data))
      ..add(ObjectFlagProperty<void Function(T? p1)?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('shrink', shrink))
      ..add(IntProperty('startFieldFlexFactor', startFieldFlexFactor))
      ..add(DiagnosticsProperty<EdgeInsets>('cardPadding', cardPadding));
  }
}

extension _UIBuilder on ZdsFieldsListTile<dynamic> {
  Widget buildDetailRow({
    required BuildContext context,
    required TileField field,
    TextStyle? fieldsStartDefaultStyle,
    TextStyle? fieldsEndDefaultStyle,
    int? startFieldFlexFactor,
  }) {
    final themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (field.start != null)
          DefaultTextStyle(
            style: fieldsStartDefaultStyle ??
                safeTextStyle(themeData.textTheme.titleSmall).copyWith(
                  color: Zeta.of(context).colors.textSubtle,
                ),
            textAlign: TextAlign.start,
            child: Flexible(flex: startFieldFlexFactor ?? 0, child: field.start!),
          )
        else
          const Spacer(),
        const SizedBox(width: 12),
        if (field.end != null)
          DefaultTextStyle(
            style: fieldsEndDefaultStyle ?? safeTextStyle(themeData.textTheme.bodyMedium),
            textAlign: TextAlign.end,
            child: Flexible(child: field.end!),
          ),
      ],
    );
  }
}

/// Pairs of data used with [ZdsFieldsListTile].
class TileField {
  /// Constructs a [TileField].
  const TileField({
    this.start,
    this.end,
  });

  /// Start widget of the data.
  final Widget? start;

  /// End widget of the data.
  final Widget? end;
}
