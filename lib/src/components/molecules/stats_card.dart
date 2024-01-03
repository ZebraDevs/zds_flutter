import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

enum _ListElement { first, middle, last }

/// A card used to display value-key pairs.
///
/// This is typically used to display key information that needs top be processed at a glance, shown in a table-like
/// format.
///
/// See also:
///
///  * [ZdsStat], used to define each statistic's properties.
class ZdsStatCard extends StatelessWidget {
  /// Displays a card with [ZdsStat] values.
  const ZdsStatCard({
    required this.stats,
    this.subtitle,
    super.key,
    this.title,
    this.isHorizontal,
    this.cardVariant = ZdsCardVariant.elevated,
  })  : assert(stats.length > 0 && stats.length < 5, 'Only 1 to 4 stats can be used.'),
        assert(title?.length != 0, "Title can't be empty if not null.");
  static const double _padding = 16;
  static const double _dividerWidth = 0.5;

  /// The stats that will be displayed in this card.
  ///
  /// Its length must be between 1 and 4.
  final List<ZdsStat> stats;

  /// The title that will be shown at the top of the card.
  ///
  /// If not null, it can't be empty.
  final String? title;

  /// The subtitle is the additional information, will be shown at the top-right side of the card.
  final String? subtitle;

  /// Whether the stats card should be shown in a horizontal row, or a vertical column.
  ///
  /// Typical behavior is horizontal, and vertical is mainly used for accessability on smaller screens.
  ///
  /// By default, screen size will be used to determine if horizontal will fit, otherwise will display vertically.
  final bool? isHorizontal;

  /// {@macro card-variant}
  final ZdsCardVariant? cardVariant;

  bool _isVertical(BuildContext context, BoxConstraints constraints) {
    final double totalPadding = stats.length * 2 * _padding;
    final double totalDividers = _dividerWidth * 0.5 * (stats.length - 1);
    final double width = (totalDividers + totalPadding - constraints.maxWidth) / -stats.length;
    for (int i = 0; i < stats.length; i++) {
      final bool description = hasTextOverflow(stats[i].description, Theme.of(context).textTheme.bodySmall!, width);
      final bool value = hasTextOverflow(
        stats[i]._valueString,
        Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 28),
        width,
      );
      if (description || value) {
        return true;
      }
    }
    return false;
  }

  double _columnWidth(BuildContext context) {
    final List<double> counter = <double>[];
    for (int i = 0; i < stats.length; i++) {
      counter.add(
        textWidth(stats[i]._valueString, Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 28)),
      );
    }
    return counter.max;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textColor = themeData.colorScheme.onSurface;

    return ZdsCard(
      variant: cardVariant ?? ZdsCardVariant.elevated,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null || subtitle != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (title != null)
                  Expanded(
                    child: Text(
                      title ?? '',
                      style: themeData.textTheme.displaySmall?.copyWith(color: textColor),
                    ),
                  )
                else
                  const SizedBox(),
                const SizedBox(width: _padding),
                if (subtitle != null)
                  Expanded(
                    flex: title != null ? 1 : 0,
                    child: Text(
                      subtitle ?? '',
                      textAlign: TextAlign.end,
                      style: themeData.textTheme.bodySmall?.copyWith(
                        color: Zeta.of(context).colors.textSubtle,
                      ),
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ).paddingOnly(bottom: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool horizontal = isHorizontal ?? !_isVertical(context, constraints);
              final double horWidth = !horizontal ? _columnWidth(context) : 0;
              final zetaColors = Zeta.of(context).colors;

              return horizontal
                  ? Row(
                      children: stats
                          .mapIndexed(
                            (int index, ZdsStat stat) => _StatElement(
                              stat: stat,
                              width: (constraints.maxWidth / stats.length) - (_dividerWidth * (stats.length - 1)),
                              type: index == 0
                                  ? _ListElement.first
                                  : index == stats.length - 1
                                      ? _ListElement.last
                                      : _ListElement.middle,
                            ),
                          )
                          .toList()
                          .divide(Container(color: zetaColors.borderSubtle, height: 43, width: _dividerWidth))
                          .toList(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: stats
                              .map(
                                (ZdsStat stat) => _HorizontalStatElement(statsList: stats, stat: stat, width: horWidth),
                              )
                              .toList(),
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<ZdsStat>('stats', stats))
      ..add(StringProperty('title', title))
      ..add(StringProperty('subtitle', subtitle))
      ..add(DiagnosticsProperty<bool?>('isHorizontal', isHorizontal))
      ..add(DiagnosticsProperty<ZdsCardVariant?>('cardVariant', cardVariant));
  }
}

class _HorizontalStatElement extends StatelessWidget {
  const _HorizontalStatElement({
    required this.statsList,
    required this.stat,
    required this.width,
  });

  final ZdsStat stat;
  final List<ZdsStat> statsList;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          width: width,
          child: Text(
            stat._valueString,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 28,
                  color: stat.color ?? Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.end,
          ),
        ),
        const SizedBox(width: 16, height: 40),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              stat.description,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ZdsStat>('stat', stat))
      ..add(IterableProperty<ZdsStat>('statsList', statsList))
      ..add(DoubleProperty('width', width));
  }
}

class _StatElement extends StatelessWidget {
  const _StatElement({required this.stat, required this.width, required this.type});

  final ZdsStat stat;
  final double width;
  final _ListElement type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: type == _ListElement.middle
          ? const EdgeInsets.symmetric(horizontal: ZdsStatCard._padding)
          : EdgeInsets.only(
              left: type == _ListElement.first ? ZdsStatCard._padding / 2 : ZdsStatCard._padding,
              right: type == _ListElement.last ? ZdsStatCard._padding / 2 : ZdsStatCard._padding,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            stat._valueString,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 28, color: stat.color ?? Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 2),
          Text(
            stat.description,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: stat.color ?? Theme.of(context).colorScheme.onSurface),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ZdsStat>('stat', stat))
      ..add(DoubleProperty('width', width))
      ..add(EnumProperty<_ListElement>('type', type));
  }
}

/// A statistic definition to be used in [ZdsStatCard].
///
/// See also:
///
///  * [ZdsStatCard], used to display multiple ZdsStat.
class ZdsStat {
  /// Creates a statistic to be used in [ZdsStatCard].
  const ZdsStat({required this.value, required this.description, this.color});

  /// The color with which this stat's value will be displayed in a [ZdsStatCard].
  ///
  /// Defaults to [ColorScheme.onSurface].
  final Color? color;

  /// This statistic's value.
  final double value;

  /// The description of this statistic.
  ///
  /// If using in [ZdsStatCard], this description should be as concise as possible.
  final String description;

  String get _valueString => value.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
}
