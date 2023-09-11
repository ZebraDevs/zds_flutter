import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../../zds_flutter.dart';

/// A circular button that can be checked and that accepts either a string or an icon as a child.
class ZdsCheckableButton extends StatelessWidget {
  /// The widget that will be shown inside the button.
  ///
  /// If this parameter is not null, [label] must be null.
  ///
  /// Typically an [Icon], or a [Text].
  final IconData? icon;

  /// The button's label.
  ///
  /// If the text is too long, it will be clipped using ellipsis. Prefer to use short strings.
  ///
  /// If this parameter is not null, [icon] must be null.
  final String? label;

  /// Whether the button is checked or not.
  ///
  /// Defaults to false.
  final bool isChecked;

  /// A callback to call whenever the user taps on the button.
  ///
  /// Typically used to setState on [isChecked].
  final VoidCallback? onChanged;

  /// Constructs a circular, checkable button.
  const ZdsCheckableButton({
    super.key,
    this.icon,
    this.label,
    this.isChecked = false,
    this.onChanged,
  }) : assert(
          icon != null && label == null || icon == null && label != null,
          'Icon and label cannot be used at the same time, either of them must be null',
        );

  @override
  Widget build(BuildContext context) {
    final ZetaColors colors = ZetaColors.of(context);
    final bool enabled = onChanged != null;
    final Color foreground =
        isChecked ? ZetaColors.computeForeground(input: Theme.of(context).colorScheme.secondary) : colors.warm.shade60;
    return MergeSemantics(
      child: Semantics(
        checked: isChecked,
        enabled: enabled,
        child: Material(
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(checkableButtonSize)),
            onTap: onChanged,
            // SizedBox declaring the dimension instead of the container allows the Text to overflow correctly
            // instead of just being clipped
            child: SizedBox.square(
              dimension: checkableButtonSize,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: enabled && !isChecked ? Border.fromBorderSide(BorderSide(color: colors.warm.shade50)) : null,
                  color: isChecked
                      ? Theme.of(context).colorScheme.secondary.withOpacity(enabled ? 1.0 : 0.5)
                      : enabled
                          ? null
                          : Theme.of(context).colorScheme.background,
                ),
                child: icon != null
                    ? Icon(icon, color: foreground)
                    : Text(
                        label ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: foreground,
                            ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<bool>('isChecked', isChecked))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onChanged', onChanged));
  }
}
