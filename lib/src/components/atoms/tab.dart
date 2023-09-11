import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../zds_flutter.dart';

/// A [Tab] with Zds styling.
class ZdsTab extends StatelessWidget {
  /// The icon shown in this tab. If [label] is also provided, the icon will be shown above it.
  final Icon? icon;

  /// The text that will be shown in this tab. If [icon] is also provided, the text will be shown below it.
  /// Must not be used at the same time than [child].
  final String? label;

  /// A widget to display below the [icon], if any. If used, [label] must be null.
  final Widget? child;

  /// Creates a [ZdsResponsiveTabBar] or [ZdsTabBar] tab. At least one of [icon], [label], or [child] must not be null.
  const ZdsTab({super.key, this.icon, this.label, this.child})
      : assert(
          icon != null || label != null || child != null,
          'At least one of icon, label, or child must be defined.',
        ),
        assert(label == null || child == null, 'One of either label or child must be defined.');

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: icon,
      text: label,
      iconMargin: const EdgeInsets.only(bottom: 4),
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
  }
}
