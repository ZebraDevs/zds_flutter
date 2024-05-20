import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

const double _itemHeight = 56;

/// A menu item used in [ZdsNavigationMenu].
///
/// This component is typically used to create buttons in a drawer menu to navigate to other apps, other parts of the
/// current app, and to change settings
///
/// While this component is typically used to redirect to other parts of the app or to other apps, it's possible to add
/// a toggle button to the [trailing] parameter to enable changing settings in the drawer itself.
///
/// ```dart
/// ZdsMenuItem(
///   title: const Text('About'),
///   leading: const Icon(ZdsIcons.info),
///   onTap: () => openAboutPage(),
///   trailing: const Icon(ZdsIcons.chevron_right),
/// ),
/// ZdsMenuItem(
///   title: const Text('Enable notifications'),
///   trailing: Switch(
///     onChanged: (value) => manageValue(value),
///     value: true,
///   ),
/// ),
/// ```
///
/// See also:
///
///  * [ZdsNavigationMenu], used to create drawer navigation menus.
class ZdsMenuItem extends StatelessWidget {
  /// Creates a menu item for navigation.
  const ZdsMenuItem({super.key, this.label, this.leading, this.title, this.trailing, this.onTap});

  /// A widget that will be shown before the title.
  ///
  /// Typically an [Icon].
  final Widget? leading;

  /// The widget that describes this item's function.
  ///
  /// Typically a [Text].
  final Widget? title;

  /// A widget that will be shown at the end of the tile.
  ///
  /// Typically an [Icon].
  final Widget? trailing;

  /// A widget that will be shown above the [leading] and [title] widgets for secondary information.
  ///
  /// Typically a [Text].
  final Widget? label;

  /// A function called whenever a user taps on this component.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Semantics(
      button: onTap != null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _itemHeight),
        child: InkWell(
          onTap: onTap,
          child: IconTheme.merge(
            data: IconThemeData(size: 24, color: Zeta.of(context).colors.iconSubtle),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (label != null) ZdsNavigationMenuLabel(child: label!),
                      Row(
                        children: <Widget>[
                          if (leading != null)
                            IconTheme.merge(
                              child: leading!,
                              data: IconThemeData(
                                color: themeData.colorScheme.secondary,
                              ),
                            ),
                          if (title != null) Expanded(child: title!),
                        ].divide(const SizedBox(width: 15)).toList(),
                      ),
                    ],
                  ).textStyle(
                    themeData.textTheme.bodyLarge?.copyWith(color: themeData.colorScheme.onSurface),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ).paddingInsets(kMenuHorizontalPadding),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}
