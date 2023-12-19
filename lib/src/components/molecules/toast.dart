import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

// TODO(colors): Add zeta

/// Determines foreground and background color of toast to comply with design rules.
///
/// * `success` = green background / grey foreground
/// * `warning` = yellow background /grey foreground
/// * `error` = red background / grey foreground
/// * `primary` = primary color background (with 0.33 lightness for contrast) / grey foreground
/// * `dark` = dark grey background / white foreground
enum ZdsToastColors {
  /// * `success` = green background / grey foreground
  success,

  /// * `warning` = yellow background /grey foreground
  warning,

  /// * `info` = purple background / grey foreground
  info,

  /// * `error` = red background / grey foreground
  error,

  /// * `primary` = primary color background (with 0.33 lightness for contrast) / grey foreground
  primary,

  /// * `dark` = dark grey background / white foreground
  dark
}

/// A container used with [ZdsSnackBarExtension.showZdsToast] to show a toast.
///
/// Typically used to confirm an action has been completed, or to notify the user of errors.
///
/// ```dart
/// ScaffoldMessenger.of(context).showZdsToast(
///   ZdsToast(
///     title: Text('Deleted file'),
///     leading: const Icon(ZdsIcons.check_circle),
///     actions: [
///       IconButton(
///         onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
///         icon: const Icon(ZdsIcons.close),
///       ),
///     ],
///     color: ZdsToastColors.success,
///   ),
/// );
/// ```
///
/// See also:
///
///  * [ZdsSnackBarExtension.showZdsToast], used to display a toast message on screen.
class ZdsToast extends StatelessWidget implements PreferredSizeWidget {
  /// The contents of a toast, typically used with [ZdsSnackBarExtension.showZdsToast].
  const ZdsToast({
    super.key,
    this.leading,
    this.title,
    this.actions,
    ZdsToastColors? color,
    this.rounded = true,
    this.multiLine = false,
  }) : color = color ?? ZdsToastColors.primary;

  /// An icon that will be shown before the [title].
  ///
  /// Typically an [Icon].
  final Widget? leading;

  /// The main content of this toast.
  ///
  /// Typically a [Text].
  final Widget? title;

  /// The actions that will be shown at the end of this widget.
  ///
  /// Typically an [IconButton] or a [ZdsButton.text].
  final List<Widget>? actions;

  /// Determines foreground and background color of toast to comply with design rules.
  ///
  /// View [ZdsToastColors] for more details.
  final ZdsToastColors color;

  /// Whether this toast will have rounded corners.
  ///
  /// Defaults to true.
  final bool rounded;

  /// Whether to clip this toast to one line or allow multiple lines.
  ///
  /// Defaults to false.
  final bool multiLine;

  Color _backgroundColor(ZetaColors colors, ZdsToastColors toastColor) {
    switch (toastColor) {
      case ZdsToastColors.success:
        return colors.positive.shade10;
      case ZdsToastColors.warning:
        return colors.warning.shade10;
      case ZdsToastColors.info:
        return colors.info.shade10;
      case ZdsToastColors.error:
        return colors.error.shade10;
      case ZdsToastColors.primary:
        return colors.primary.shade10;
      case ZdsToastColors.dark:
        return colors.textDefault;
    }
  }

  Color _iconColor(ZetaColors colors, ZdsToastColors toastColor) {
    switch (toastColor) {
      case ZdsToastColors.success:
        return colors.green.shade60;
      case ZdsToastColors.warning:
        return colors.orange.shade60;
      case ZdsToastColors.info:
        return colors.info.shade60;
      case ZdsToastColors.error:
        return colors.error.shade60;
      case ZdsToastColors.primary:
        return colors.primary.shade60;
      case ZdsToastColors.dark:
        return colors.textInverse;
    }
  }

  Color _foregroundColor(ZetaColors colors, ZdsToastColors toastColor) {
    if (toastColor == ZdsToastColors.dark) {
      return colors.textInverse;
    } else {
      return colors.textDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;
    final foregroundColor = _foregroundColor(zetaColors, color);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: rounded ? 8.0 : 0),
          child: Material(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                multiLine
                    ? 6
                    : rounded
                        ? 49
                        : 0,
              ),
            ),
            color: _backgroundColor(zetaColors, color),
            child: Container(
              constraints: const BoxConstraints(minHeight: kToastHeight),
              padding: EdgeInsets.only(left: 18, top: multiLine ? 14 : 0, bottom: multiLine ? 14 : 0, right: 10),
              child: Row(
                children: <Widget>[
                  if (leading != null)
                    IconTheme(
                      data: IconThemeData(color: _iconColor(zetaColors, color)),
                      child: leading!,
                    ),
                  Expanded(
                    child: title != null
                        ? DefaultTextStyle(
                            style: safeTextStyle(Theme.of(context).textTheme.bodyLarge).copyWith(
                              color: foregroundColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: multiLine ? 5 : 1,
                            child: title!,
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (actions != null && actions!.isNotEmpty)
                    IconTheme(
                      data: IconThemeData(color: foregroundColor),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions!.divide(const SizedBox(width: 10)).toList(),
                      ),
                    ),
                ].divide(const SizedBox(width: 10)).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToastHeight);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ZdsToastColors?>('color', color))
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(DiagnosticsProperty<bool>('multiLine', multiLine));
  }
}

/// Extension to show a ZdsToast
extension ZdsSnackBarExtension on ScaffoldMessengerState {
  /// Shows a [ZdsToast].
  ///
  /// * [duration] sets how many seconds the toast is shown on screen, defaulting to 4.
  /// * [padding] defines the space to set around the toast, defaulting to EdgeInsets.only(bottom: 8).
  ///
  /// ```dart
  /// ScaffoldMessenger.of(context).showZdsToast(ZdsToast());
  /// ```
  ///
  /// See also:
  ///
  ///  * [ZdsToast], used to define the toast's contents
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showZdsToast(
    ZdsToast toast, {
    Duration duration = const Duration(seconds: 4),
    EdgeInsets padding = const EdgeInsets.only(bottom: 8),
  }) {
    return showSnackBar(
      SnackBar(
        content: toast,
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        padding: padding,
        duration: duration,
      ),
    );
  }
}
