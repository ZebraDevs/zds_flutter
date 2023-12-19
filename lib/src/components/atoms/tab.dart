import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../molecules/responsive_tab_bar.dart';
import '../molecules/tab_bar.dart';

/// A [Tab] with Zebra styling.
class ZdsTab extends StatelessWidget {
  /// Creates a [ZdsResponsiveTabBar] or [ZdsTabBar] tab. At least one of [icon], [label], or [child] must not be null
  const ZdsTab({super.key, this.icon, this.label, this.child, this.semanticLabel})
      : assert(
          icon != null || label != null || child != null,
          'At least one of icon, label, or child must be defined.',
        ),
        assert(label == null || child == null, 'One of either label or child must be defined.');

  /// The icon shown in this tab. If [label] is also provided, the icon will be shown above it.
  ///
  /// It is recommended the child is an [Icon], other Widget types may not work correctly.
  ///
  /// This component will always be constrained to a size of 24 x 24.
  final Widget? icon;

  /// The text that will be shown in this tab. If [icon] is also provided, the text will be shown below it.
  /// Must not be used at the same time than [child]
  final String? label;

  /// A widget to display below the [icon], if any. If used, [label] must be null.
  final Widget? child;

  /// Semantic label for tab.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Tab(
        icon: icon,
        text: label,
        iconMargin: const EdgeInsets.only(bottom: 4),
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(StringProperty('semanticLabel', semanticLabel));
  }
}
