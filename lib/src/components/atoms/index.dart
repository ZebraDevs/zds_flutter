import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/tools/utils.dart';
import '../molecules/tag.dart';

/// A component used to show status information, like index, order, or state, in a very small space.
///
/// This component is typically used with a [Text] containing one letter or one number. This is meant to show important
/// information, like priority (using numbers), status (using a letter code like 'D' = 'Done', 'P' = 'In Progress'), or
/// alerts (showing '!' and using a red color) in a small area of the screen. Generally, this is used in lists where
/// each element has a status that needs to be understood quickly and transmitted in a succinct manner.
///
/// See also:
///
///  * [ZdsTag], which uses this component in its prefix.
class ZdsIndex extends StatelessWidget {
  /// Creates a small circle used to show status information at a glance.
  /// This circle is optional to cater for when a leading icon is required, without a circle.
  /// An example of this is 'Approved' with a leading check icon.
  const ZdsIndex({super.key, this.child, this.color, this.useBoxDecoration = true});

  /// The background color of the circle.
  ///
  /// Defaults to [ColorScheme.primaryContainer].
  final Color? color;

  /// The widget that will be shown in the circle.
  ///
  /// Typically a [Text] widget.
  final Widget? child;

  /// This is an option to have a small circle or not on the leading element of a tag.
  ///
  /// If rectangular boolean is false in [ZdsTag], this defaults to true.
  final bool useBoxDecoration;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final bgColor = color ?? themeData.colorScheme.primaryContainer;
    return Container(
      width: 20,
      height: 20,
      margin: !useBoxDecoration ? const EdgeInsets.only(left: 6) : EdgeInsets.zero,
      decoration: useBoxDecoration
          ? BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            )
          : const BoxDecoration(),
      child: Center(
        child: DefaultTextStyle(
          style: safeTextStyle(themeData.textTheme.bodySmall).copyWith(
            color: useBoxDecoration ? bgColor.onColor : themeData.colorScheme.onSurface,
          ),
          child: child ?? const SizedBox(),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(DiagnosticsProperty<bool>('useBoxDecoration', useBoxDecoration));
  }
}
