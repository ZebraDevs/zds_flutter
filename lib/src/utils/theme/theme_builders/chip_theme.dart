import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

/// This is an extension method on [ZetaColorScheme] which is used to customize the [ChipThemeData].
extension ZetaChipTheme on ZetaColorScheme {
  /// This function requires a [TextTheme] object as a parameter, and
  /// returns a [ChipThemeData] customized with properties taken from the [ZetaColorScheme] and the passed TextTheme.
  ///
  /// Parameter:
  ///   [textTheme] : A TextTheme object used to copy styles for label and secondary label.
  ///
  /// Returns:
  ///   A [ChipThemeData] with the applied properties.
  ChipThemeData chipThemeData(TextTheme textTheme) {
    /// Returns ChipThemeData after assigning properties like
    /// backgroundColor, selectedColor, disabledColor, deleteIconColor,
    /// checkmarkColor, labelStyle, secondaryLabelStyle and iconTheme.
    return ChipThemeData(
      /// Setting up the background color.
      backgroundColor: zetaColors.secondary.surface,

      /// Setting up the selected color.
      selectedColor: zetaColors.secondary.surface,

      /// Setting up the disabled color.
      disabledColor: zetaColors.borderDisabled,

      /// Setting up the delete icon color.
      deleteIconColor: zetaColors.secondary.selected,

      /// Setting up the checkmark color.
      checkmarkColor: zetaColors.secondary.selected,

      /// Defining the label style using the provided textTheme.
      labelStyle: textTheme.bodyMedium?.copyWith(color: zetaColors.secondary.selected),

      /// Defining the secondary label style using the provided textTheme.
      secondaryLabelStyle: textTheme.bodyMedium?.copyWith(color: zetaColors.textSubtle),

      // Defining an icon theme data.
      iconTheme: IconThemeData(
        size: 24,
        color: zetaColors.secondary.selected,
      ),
    );
  }
}
