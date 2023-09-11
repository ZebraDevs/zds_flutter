import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

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
  /// Defaults to [TextTheme.titleSmall] with [ZdsColors.blueGrey] color.
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

  @override
  Widget build(BuildContext context) {
    return ZdsCard(
      padding: cardPadding,
      onTap: onTap != null ? () => onTap!.call(data) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyLarge!,
              child: title!,
            ).space(),
          if (fields != null)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => buildDetailRow(
                context: context,
                field: fields![index],
                fieldsStartDefaultStyle: fieldsStartTextStyle,
                fieldsEndDefaultStyle: fieldsEndTextStyle,
                startFieldFlexFactor: startFieldFlexFactor,
              ),
              separatorBuilder: (_, index) =>
                  SizedBox(height: fields?[index].start != null && fields?[index].end != null ? (shrink ? 10 : 18) : 0),
              itemCount: fields!.length,
            ),
          if (footnote != null)
            Column(
              children: [
                const SizedBox(height: 8),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: ZdsColors.greySwatch(context)[900],
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
    properties.add(IterableProperty<TileField>('fields', fields));
    properties.add(DiagnosticsProperty<TextStyle?>('fieldsStartTextStyle', fieldsStartTextStyle));
    properties.add(DiagnosticsProperty<TextStyle?>('fieldsEndTextStyle', fieldsEndTextStyle));
    properties.add(DiagnosticsProperty<T?>('data', data));
    properties.add(ObjectFlagProperty<void Function(T? p1)?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('shrink', shrink));
    properties.add(IntProperty('startFieldFlexFactor', startFieldFlexFactor));
    properties.add(DiagnosticsProperty<EdgeInsets>('cardPadding', cardPadding));
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.start != null)
          DefaultTextStyle(
            style:
                fieldsStartDefaultStyle ?? Theme.of(context).textTheme.titleSmall!.copyWith(color: ZdsColors.blueGrey),
            textAlign: TextAlign.start,
            child: Flexible(flex: startFieldFlexFactor ?? 0, child: field.start!),
          )
        else
          const Spacer(),
        const SizedBox(width: 12),
        if (field.end != null)
          DefaultTextStyle(
            style: fieldsEndDefaultStyle ?? Theme.of(context).textTheme.bodyMedium!,
            textAlign: TextAlign.end,
            child: Flexible(child: field.end!),
          ),
      ],
    );
  }
}

/// Pairs of data used with [ZdsFieldsListTile].
class TileField {
  /// Start widget of the data.
  final Widget? start;

  /// End widget of the data.
  final Widget? end;

  /// Constructs a [TileField].
  const TileField({
    this.start,
    this.end,
  });
}
