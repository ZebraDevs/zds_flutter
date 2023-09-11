import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import 'routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final Map<String, ZetaColorSwatch> colorMap = {
  'Red': ZetaColorBase.red,
  'Orange': ZetaColorBase.orange,
  'Yellow': ZetaColorBase.yellow,
  'Green': ZetaColorBase.green,
  'Blue': ZetaColorBase.blue,
  'Teal': ZetaColorBase.teal,
  'Pink': ZetaColorBase.pink,
};

const String _darkModeKey = 'dark';

class _HomePageState extends State<HomePage> {
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext _) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ZDS_Flutter Demo'),
          centerTitle: true,
          actions: [
            ZdsPopupMenu(
              onSelected: (dynamic val) {
                if (val is ZetaColorSwatch) {
                  ZetaColors.setColors(context, ZetaColors(primary: val, secondary: val));
                } else if (val is String && val == _darkModeKey) {
                  ZetaColors.setDarkMode(context, !ZetaColors.of(context).isDarkMode);
                }
                setState(() {
                  key = GlobalKey();
                });
              },
              builder: (_, open) => IconButton(
                splashRadius: 20,
                visualDensity: VisualDensity.compact,
                onPressed: open,
                icon: const Icon(ZdsIcons.more_vert),
              ),
              items: [
                ...colorMap.entries
                    .map(
                      (e) => ZdsPopupMenuItem(
                        value: e.value,
                        child: ListTile(
                          visualDensity: VisualDensity.compact,
                          title: Text(e.key),
                        ),
                      ),
                    )
                    .toList(),
                ZdsPopupMenuItem(
                  value: _darkModeKey,
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    title: Text(ZetaColors.of(context).isDarkMode ? 'Light mode' : 'Dark mode'),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Builder(
            key: key,
            builder: (context) {
              print('BUILDERING');
              return ZdsList.builder(
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
              );
            }),
      );
    });
  }
}
