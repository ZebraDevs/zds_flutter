import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../../zds_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    final Color background =
        color?.surface ?? selectedColor ?? Theme.of(context).colorScheme.secondary.withOpacity(0.1);
    final Color disabledColor = color?.disabled ?? ZdsColors.greyWarmSwatch[100]!;
    final Color border = color?.border ?? borderColor ?? ZdsColors.greyCoolSwatch[100]!;

    final Color selectedForeground = color?.icon ??
        (selectedColor != null ? computeForeground(selectedColor!) : Theme.of(context).colorScheme.secondary);

    final disabled = onTap == null;

    return ExpandTapWidget(
      onTap: onTap ?? () {},
      tapPadding: padding,
      child: MergeSemantics(
        child: Semantics(
          checked: selected,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minWidth: 50),
            padding: padding,
            child: Material(
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(19)),
                onTap: onTap,
                child: AnimatedContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: selected ? border : Colors.transparent,
                      ),
                    ),
                    color: disabled
                        ? disabledColor
                        : selected
                            ? background
                            : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (leadingIcon != null)
                        IconTheme(
                          data: IconThemeData(color: selectedForeground),
                          child: Row(children: [leadingIcon!, const SizedBox(width: 8)]),
                        ),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: disabled
                                  ? ZdsColors.greyWarmSwatch[1000]
                                  : selected
                                      ? color?.text ?? selectedForeground
                                      : Theme.of(context).colorScheme.onSurface,
                              fontWeight: selected && !disabled ? FontWeight.w600 : null,
                            ),
                      ),
                      if (onClose != null)
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            IconButton(
                              constraints: const BoxConstraints(maxHeight: 24, maxWidth: 24),
                              onPressed: onClose,
                              icon: Icon(
                                ZdsIcons.close,
                                color: selected ? Theme.of(context).colorScheme.secondary : ZdsColors.blueGrey,
                              ),
                              splashRadius: 16,
                              iconSize: 16,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                    ],
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
    properties.add(StringProperty('label', label));
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onClose', onClose));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(ColorProperty('selectedColor', selectedColor));
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(ColorProperty('color', color));
  }
}
