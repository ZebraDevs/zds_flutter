import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class ZetaThemeModeSwitch extends StatelessWidget {
  ZetaThemeModeSwitch({super.key});

  late final _themes = [
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark,
  ];

  @override
  Widget build(BuildContext context) {
    var zeta = Zeta.of(context);

    ZetaColors zetaColors(ThemeMode mode) {
      if ((mode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.light) ||
          mode == ThemeMode.light) {
        return zeta.themeData.colorsLight;
      } else {
        return zeta.themeData.colorsDark;
      }
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<ThemeMode>(
        value: zeta.themeMode,
        elevation: 0,
        isDense: true,
        alignment: Alignment.center,
        icon: SizedBox(width: 0),
        dropdownColor: zeta.colors.borderDisabled,
        padding: EdgeInsets.all(ZetaSpacing.small),
        items: _themes.map((e) {
          final colors = zetaColors(e).apply(contrast: zeta.contrast);
          return DropdownMenuItem<ThemeMode>(
            value: e,
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: colors.primary.surface,
              foregroundColor: colors.primary,
              child: Icon(
                  e == ThemeMode.system
                      ? Icons.system_security_update_good
                      : e == ThemeMode.light
                          ? Icons.light_mode
                          : Icons.dark_mode,
                  color: colors.primary),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            ZetaProvider.of(context).updateThemeMode(value);
          }
        },
      ),
    );
  }
}
