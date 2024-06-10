import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class ZetaThemeColorSwitch extends StatelessWidget {
  ZetaThemeColorSwitch({super.key});

  late final _themes = {
    "default": ZetaThemeData(
      primary: ZetaColorBase.blue,
      secondary: ZetaColorBase.blue,
    ),
    "teal": ZetaThemeData(
      identifier: 'teal',
      primary: ZetaColorBase.teal,
      secondary: ZetaColorBase.teal,
    ),
    "yellow": ZetaThemeData(
      identifier: 'yellow',
      primary: ZetaColorBase.yellow,
      secondary: ZetaColorBase.yellow,
    ),
    "red": ZetaThemeData(
      identifier: 'red',
      primary: ZetaColorBase.red,
      secondary: ZetaColorBase.red,
    ),
    "purple": ZetaThemeData(
      identifier: 'purple',
      primary: ZetaColorBase.purple,
      secondary: ZetaColorBase.purple,
    ),
  };

  @override
  Widget build(BuildContext context) {
    var zeta = Zeta.of(context);

    ZetaColors primary(ZetaThemeData data) {
      if (zeta.brightness == Brightness.light) {
        return data.colorsLight;
      } else {
        return data.colorsDark;
      }
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: zeta.themeData.identifier,
        elevation: 0,
        isDense: true,
        alignment: Alignment.center,
        icon: SizedBox(width: 0),
        padding: EdgeInsets.all(ZetaSpacing.small),
        dropdownColor: zeta.colors.borderDisabled,
        items: _themes.entries.map((e) {
          var zetaColors = primary(_themes[e.key]!).apply(contrast: zeta.contrast);
          var color = zetaColors.primary;
          return DropdownMenuItem<String>(
            value: e.value.identifier,
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: color.surface,
              foregroundColor: color,
              child: Icon(Icons.color_lens, color: color),
            ),
          );
        }).toList(),
        onChanged: (value) {
          final theme = _themes[value];
          if (theme != null) {
            ZetaProvider.of(context).updateThemeData(theme);
          }
        },
      ),
    );
  }
}
