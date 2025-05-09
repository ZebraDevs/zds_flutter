import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

/// This is an extension method on [ZetaSemantics] which is used to customize the [ChipThemeData].
extension ZetaChipTheme on ZetaSemantics {
  /// This function requires a [TextTheme] object as a parameter, and
  /// returns a [ChipThemeData] customized with properties taken from the [ZetaSemantics] and the passed TextTheme.
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
      backgroundColor: colors.surfaceSecondary,

      /// Setting up the selected color.
      selectedColor: colors.surfaceSecondary,

      /// Setting up the disabled color.
      disabledColor: colors.borderDisabled,

      /// Setting up the delete icon color.
      deleteIconColor: colors.stateSecondarySelected,

      /// Setting up the checkmark color.
      checkmarkColor: colors.stateSecondarySelected,

      /// Defining the label style using the provided textTheme.
      labelStyle: textTheme.bodyMedium?.copyWith(color: colors.stateSecondarySelected),

      /// Defining the secondary label style using the provided textTheme.
      secondaryLabelStyle: textTheme.bodyMedium?.copyWith(color: colors.mainSubtle),

      // Defining an icon theme data.
      iconTheme: IconThemeData(size: 24, color: colors.stateSecondarySelected),
    );
  }
}
