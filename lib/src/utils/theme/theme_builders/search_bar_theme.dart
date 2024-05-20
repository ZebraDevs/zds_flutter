import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

/// An extension on [ZetaColorScheme].
///
/// This extension adds a method [searchBarTheme], which allows for customizing
/// the appearance of a SearchBar using the [ZetaColorScheme] and a given [TextTheme].
extension SearchBarExtension on ZetaColorScheme {
  /// Creates and returns a [SearchBarThemeData] object.
  ///
  /// Text styles, color and elevation of the SearchBar can be customized through this method.
  /// TextStyles are derived from the given TextTheme.
  /// WidgetStateProperties are used to create resolvable properties for different UI states..
  SearchBarThemeData searchBarTheme(TextTheme textTheme) {
    return SearchBarThemeData(
      /// Defines the hintStyle - The style of hint text to display in the SearchBar
      /// when no text has been entered.
      hintStyle: WidgetStateProperty.all(textTheme.bodyMedium?.copyWith(color: zetaColors.textSubtle)),

      /// Defines the textStyle - The style of text to display in the SearchBar
      /// when the user has entered text.
      textStyle: WidgetStateProperty.all(textTheme.bodyMedium),

      /// Defines the elevation (shadow size) for the SearchBar
      elevation: WidgetStateProperty.all(2),
    );
  }
}
