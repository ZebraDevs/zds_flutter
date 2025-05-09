import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../zds_flutter.dart';

/// A widget that represents an icon with a label.
///
/// This widget displays an icon and a label below it. It also provides an
/// optional callback function that is triggered when the icon is tapped.
class EditorIcon extends StatelessWidget {
  /// Creates an [EditorIcon] widget.
  ///
  /// The [icon] and [label] parameters are required. The [onPressed] parameter
  /// is optional and can be used to provide a callback function.
  const EditorIcon({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onPressed,
  });

  /// The icon to be displayed.
  final Icon icon;

  /// The label to be displayed below the icon.
  final String label;

  ///
  final bool isSelected;

  /// The callback function to be triggered when the icon is tapped.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          icon,
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(color: isSelected ? zetaColors.mainPrimary : null),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(ObjectFlagProperty<void Function()?>.has('onPressed', onPressed))
      ..add(DiagnosticsProperty<bool>('isSelected', isSelected));
  }
}
