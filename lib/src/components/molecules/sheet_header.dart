import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../../../zds_flutter.dart';

/// Creates the header component for a bottom sheet with Zds style.
class ZdsSheetHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Constructs a [ZdsSheetHeader].
  const ZdsSheetHeader({
    required this.headerText,
    super.key,
    this.leading,
    this.trailing,
    this.busy = false,
    this.headerTextStyle,
  });
  static const double _kSheetHeight = 54;

  /// Sheet header title of type [String].
  final String headerText;

  /// The Widget that is displayed before the title, typically an [IconButton] widget.
  final Widget? leading;

  /// The widget that is displayed after the title, typically a clickable widget.
  final Widget? trailing;

  /// Indicates whether the application is busy or not.
  ///
  /// The default value is false.
  final bool busy;

  /// The text style for the sheet header
  ///
  /// Defaults to [TextTheme.headlineMedium].
  final TextStyle? headerTextStyle;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Semantics(
      child: Container(
        color: themeData.colorScheme.surface,
        height: _kSheetHeight,
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            top: false,
            bottom: false,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    headerText,
                    style: headerTextStyle ?? themeData.textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                    textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 2),
                  ),
                ).paddingOnly(bottom: 5),
                if (leading != null)
                  leading is IconButton || leading is Icon
                      ? Container(
                          height: _kSheetHeight,
                          padding: EdgeInsets.only(left: context.isTablet() ? 0 : 16),
                          child: Material(
                            shape: const CircleBorder(),
                            color: Colors.transparent,
                            clipBehavior: Clip.antiAlias,
                            child: Semantics(
                              sortKey: const OrdinalSortKey(1),
                              child: IconTheme(
                                data: themeData.iconTheme.copyWith(
                                  color: Zeta.of(context).colors.iconSubtle,
                                  size: 24,
                                ),
                                child: leading!,
                              ),
                            ),
                          ),
                        )
                      : Semantics(
                          sortKey: const OrdinalSortKey(1),
                          child: SizedBox(height: _kSheetHeight, child: UnconstrainedBox(child: leading)),
                        ).paddingOnly(left: 10),
                if (trailing != null)
                  Positioned(
                    right: 8,
                    child: Semantics(
                      sortKey: const OrdinalSortKey(2),
                      child: SizedBox(height: _kSheetHeight, child: UnconstrainedBox(child: trailing)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_kSheetHeight);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('headerText', headerText))
      ..add(DiagnosticsProperty<bool>('busy', busy))
      ..add(DiagnosticsProperty<TextStyle?>('headerTextStyle', headerTextStyle));
  }
}
