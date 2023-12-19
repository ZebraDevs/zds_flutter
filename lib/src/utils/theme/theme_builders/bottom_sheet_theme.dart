import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

/// An extension of the [ZetaColorScheme] that provides a BottomSheet theme design.
extension ZetaBottomSheetTheme on ZetaColorScheme {
  /// Creates and returns a themed [BottomSheetThemeData].
  ///
  /// The [BottomSheetThemeData] uses a custom shape border for
  /// the bottom sheet.
  BottomSheetThemeData bottomSheetTheme() {
    return const BottomSheetThemeData(
      /// The shape of the bottom sheet, defined as a [RoundedRectangleBorder].
      ///
      /// This setting sets a custom shape for the border of the bottom sheet.
      /// The top right and top left corners of the bottom sheet will be rounded
      /// with a circular radius of 14.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          // Top-left corner circular radius is set to 14.
          topLeft: Radius.circular(14),

          // Top-right corner circular radius is set to 14.
          topRight: Radius.circular(14),
        ),
      ),
    );
  }
}
