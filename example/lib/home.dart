import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'package:zds_flutter_example/main.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import 'routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final Map<String, dynamic> colorMap = {
  'Brand blue': BrandColors.zdsDefault(),
  'Brand red': brandRed,
  'Zebra Colors': ZebraColors,
  'Zeta Blue': ZetaColorBase.blue,
  'Zeta Orange': ZetaColorBase.orange,
  'Zeta Pink': ZetaColorBase.pink,
  'Zeta Purple': ZetaColorBase.purple,
  'Zeta Teal': ZetaColorBase.teal,
};

BrandColors brandRed = BrandColors(
  light: ZdsColorScheme.light(
    primary: const Color(0xFFC80000),
    primaryContainer: const Color(0xFFA1050D),
    secondary: const Color(0xFF00B2C1),
    secondaryContainer: const Color(0xFF098490),
  ),
  dark: ZdsColorScheme.dark(
    primary: const Color(0xFFC80000),
    primaryContainer: const Color(0xFFA1050D),
    secondary: const Color(0xFF00B2C1),
    secondaryContainer: const Color(0xFF098490),
  ),
);

BrandColors ZebraColors = BrandColors(
  light: ZdsColorScheme.light(
    primary: const Color(0xFF151519),
    primaryContainer: const Color(0xFF1D1E23),
    secondary: const Color(0xFF0073E6),
    secondaryContainer: const Color(0xFFE8EBF1),
  ),
  dark: ZdsColorScheme.dark(
    primary: const Color(0xFF151519),
    primaryContainer: const Color(0xFF1D1E23),
    secondary: const Color(0xFF0073E6),
    secondaryContainer: const Color(0xFFE8EBF1),
  ),
);

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZDS_Flutter Demo'),
        centerTitle: true,
        actions: [
          ZdsPopupMenu(
            onSelected: (dynamic val) {
              /// This is for demonstration purposes only.
              /// Apps should use one of:
              /// * BrandColors  - ThemeProvider.of(context).setColors(...)
              /// * ZetaColors - ZetaColors.of(context).setColors(...)
              final state = context.findAncestorStateOfType<DemoAppState>();
              if (val is BrandColors) {
                if (state?.brandColors == null) {
                  state?.brandColors = val;
                  state?.zetaColors = null;
                } else {
                  ThemeProvider.of(context)!.setColors(val);
                }
              } else if (val is ZetaColorSwatch) {
                if (state?.zetaColors == null) {
                  state?.zetaColors = val;
                  state?.brandColors = null;
                } else {
                  ZetaColors.setColors(
                    context,
                    ZetaColors(primary: val, secondary: val, isDarkMode: ZetaColors.of(context).isDarkMode),
                  );
                }
              } else if (val is bool) {
                ZetaColors.setDarkMode(context, val);
                if (state?.brandColors != null) {
                  ThemeProvider.of(context)?.setDarkMode(isDark: val);
                }
              }
              setState(() {});
            },
            builder: (_, open) => IconButton(onPressed: open, icon: const Icon(ZdsIcons.palette)),
            items: [
              ...colorMap.entries
                  .map(
                    (e) => ZdsPopupMenuItem(
                      value: e.value,
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        title: Text(e.key),
                        trailing: Icon(
                          Icons.check,
                          size: 20,
                          color: isSelectedColor(e.value) ? ZdsColors.green : Colors.transparent,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              ZdsPopupMenuItem(
                value: !ZetaColors.of(context).isDarkMode,
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  title: Text(ZetaColors.of(context).isDarkMode ? 'Light mode' : 'Dark mode'),
                ),
              ),
            ],
          )
        ],
      ),
      body: ZdsList.builder(
        padding: const EdgeInsets.symmetric(vertical: 14),
        itemCount: kRoutes.length,
        itemBuilder: (context, index) {
          final rec = kRoutes.entries.toList()[index];
          final items = rec.value..sort((a, b) => a.title.compareTo(b.title));
          return ZdsExpansionTile(
            title: Text(
              rec.key,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ZetaColors.of(context).textDefault,
                  ),
            ),
            child: ZdsListGroup(
              items: items.map((route) {
                return ZdsListTile(
                    title: Text(route.title),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: ZetaColors.of(context).textDefault,
                    ),
                    onTap: () => Navigator.of(context).pushNamed(route.routeName));
              }).toList(),
            ).space(14),
          );
        },
      ),
    );
  }

  bool isSelectedColor(dynamic val) {
    final state = context.findAncestorStateOfType<DemoAppState>();
    if (val is ZetaColorSwatch && state?.zetaColors != null) {
      return val.primary == ZetaColors.of(context).primary.primary ||
          val.primary == ZetaColors.of(context).primary.shade50;
    } else if (val is BrandColors && state?.brandColors != null) {
      return val == ThemeProvider.of(context)?.colors;
    }
    return false;
  }
}
