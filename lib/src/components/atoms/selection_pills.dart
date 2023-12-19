import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/assets/icons.dart';
import '../../utils/tools/modifiers.dart';

/// A text button that can be selectable and that accepts a string and isButtonSelected boolean value.
///
///
/// /// ```dart
/// ZdsSelectionPills(
///   isButtonSelected: isButtonSelected,
///   label: 'Approved',
///    onChanged: () =>
///      setState(() => isButtonSelected = !isButtonSelected)
///  ),
///
/// /// ```
class ZdsSelectionPill extends StatelessWidget {
  /// Constructs a circular, checkable button.
  const ZdsSelectionPill({
    required this.label,
    super.key,
    this.selected = false,
    this.onTap,
    this.leadingIcon,
    this.onClose,
    this.padding = const EdgeInsets.all(9),
    this.color,
    this.selectedColor,
    this.borderColor,
  });

  /// The button's label.
  ///
  /// Prefer to use short strings.
  final String label;

  /// Whether the button is selected or not.
  ///
  /// Defaults to false.
  final bool selected;

  /// The icon to be displayed in the chip before the label.
  final Icon? leadingIcon;

  /// A callback to call whenever the user taps on the button.
  ///
  /// Typically used to setState on [selected].
  final VoidCallback? onTap;

  /// A callback to call when the pill's close button is pressed.
  ///
  /// If this argument is null, the close button will be hidden.
  final VoidCallback? onClose;

  /// Padding that wraps the selection pill.
  ///
  /// Defaults to `EdgeInsets.all(9)`.
  final EdgeInsets padding;

  /// Color swatch
  ///
  /// Defaults to primary.
  final ZetaColorSwatch? color;

  ///Use [color] instead. Will be deprecated in future release.
  ///
  /// Custom color to override pill background color.
  ///
  ///Defaults to `colorScheme.secondary.withOpacity(0.1)`
  final Color? selectedColor;

  ///Use [color] instead. Will be deprecated in future release.
  ///
  /// Custom color to override unselected pill border color.
  ///
  /// Defaults to `ZdsColors.greyCoolSwatch[100]`.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;
    final themeData = Theme.of(context);
    final bool disabled = onTap == null;

    final Color background = disabled
        ? zetaColors.surfaceDisabled
        : selected
            ? color?.surface ?? selectedColor?.withOpacity(0.2) ?? zetaColors.secondary.surface
            : themeData.colorScheme.surface;

    final Color foreground = disabled
        ? zetaColors.iconDisabled
        : selected
            ? color?.icon ?? selectedColor ?? zetaColors.secondary.icon
            : zetaColors.iconSubtle;

    final Color border = borderColor ??
        (disabled
            ? zetaColors.borderDisabled
            : selected
                ? color?.border ?? zetaColors.secondary.border
                : zetaColors.borderDefault);

    return ExpandTapWidget(
      onTap: onTap ?? () {},
      tapPadding: padding,
      child: MergeSemantics(
        child: Semantics(
          checked: selected,
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(19)),
              child: Material(
                color: background,
                child: InkWell(
                  onTap: onTap,
                  child: AnimatedContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    duration: const Duration(milliseconds: 200),
                    constraints: const BoxConstraints(minWidth: 50),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      border: Border.fromBorderSide(BorderSide(color: border)),
                      color: background,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (leadingIcon != null)
                          IconTheme(
                            data: IconThemeData(color: foreground),
                            child: leadingIcon!.paddingOnly(right: 8),
                          ),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: themeData.textTheme.bodyMedium?.copyWith(
                            color: disabled
                                ? zetaColors.textDisabled
                                : selected
                                    ? color?.text ?? foreground
                                    : themeData.colorScheme.onSurface,
                            fontWeight: selected && !disabled ? FontWeight.w600 : null,
                          ),
                        ),
                        if (onClose != null)
                          IconButton(
                            constraints: const BoxConstraints(maxHeight: 24, maxWidth: 24),
                            onPressed: onClose,
                            icon: Icon(ZdsIcons.close, color: foreground),
                            splashRadius: 16,
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                          ).paddingOnly(left: 10),
                      ],
                    ),
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
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<bool>('selected', selected))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onClose', onClose))
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding))
      ..add(ColorProperty('selectedColor', selectedColor))
      ..add(ColorProperty('borderColor', borderColor))
      ..add(ColorProperty('color', color));
  }
}
