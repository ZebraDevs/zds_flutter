import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// Creates a message about no results being returned.
///
/// This widget can be used to show a message for, when example, a search returns no results, or when no options are
/// available. Typically, this widget is shown instead of the results list when the list is empty.
class ZdsEmpty extends StatelessWidget {
  /// Creates a message about no results being returned.
  const ZdsEmpty({super.key, this.icon, this.message});

  /// The icon used for this message.
  ///
  /// Typically an [Icon].
  final Widget? icon;

  /// The message to display.
  ///
  /// Typically a [Text].
  final Widget? message;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Align(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Icon
          if (!(context.isShortScreen() || context.isSmallScreen() || (context.isPhone() && context.isLandscape())))
            ExcludeSemantics(
              child: IconTheme(
                data: IconThemeData(
                  color: themeData.colorScheme.secondary,
                  size: 72,
                ),
                child: icon ??
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 3),
                      child: ZdsImages.emptyBox,
                    ),
              ).space(40),
            ),
          // Message
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: MergeSemantics(
                  child: message ??
                      Text(
                        ComponentStrings.of(context).get('NO_RESULTS', 'No results'),
                        textAlign: TextAlign.center,
                      ),
                ).textStyle(
                  themeData.textTheme.displayMedium,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
