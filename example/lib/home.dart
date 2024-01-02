import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'package:zds_flutter_example/pages/utils/theme_color_switch.dart';
import 'package:zds_flutter_example/pages/utils/theme_constrast_switch.dart';
import 'package:zds_flutter_example/pages/utils/theme_mode_switch.dart';

import 'routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext _) {
    final zeta = Zeta.of(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        leading: SizedBox(width: 20),
        title: const Text('ZDS Demo'),
        centerTitle: false,
        actions: [
          ZetaThemeModeSwitch(),
          ZetaThemeContrastSwitch(),
          ZetaThemeColorSwitch(),
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
                    color: zeta.colors.textDefault,
                  ),
            ),
            child: ZdsListGroup(
              items: items.map((route) {
                return ZdsListTile(
                    title: Text(route.title),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: zeta.colors.iconSubtle,
                    ),
                    onTap: () => Navigator.of(context).pushNamed(route.routeName));
              }).toList(),
            ).space(14),
          );
        },
      ),
    );
  }
}
