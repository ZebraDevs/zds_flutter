import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// Creates a list to show multiple [ZdsTag].
///
/// If [direction] is [Axis.horizontal], the items will wrap around if they don't fit.
class ZdsTagsList extends StatelessWidget {
  /// Creates a list of [ZdsTag].
  const ZdsTagsList({
    super.key,
    this.items,
    this.direction = Axis.vertical,
    this.horizontalSpace = 8,
    this.verticalSpace = 6,
  });

  /// This list's items.
  final List<ZdsTag>? items;

  /// The direction of this list.
  ///
  /// If [Axis.horizontal], the items will wrap around if they don't fit.
  ///
  /// Defaults to [Axis.vertical].
  final Axis direction;

  /// Defines the horizontal separation between tags.
  ///
  /// Defaults to 8.
  final double horizontalSpace;

  /// Defines the vertical separation between tags.
  ///
  /// Defaults to 6.
  final double verticalSpace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Wrap(
          direction: direction,
          spacing: direction == Axis.vertical ? verticalSpace : horizontalSpace,
          runSpacing: direction == Axis.vertical ? horizontalSpace : verticalSpace,
          children: items ?? <Widget>[],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Axis>('direction', direction))
      ..add(DoubleProperty('horizontalSpace', horizontalSpace))
      ..add(DoubleProperty('verticalSpace', verticalSpace));
  }
}
