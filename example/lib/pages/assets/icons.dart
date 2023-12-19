import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class IconsDemo extends StatefulWidget {
  const IconsDemo({Key? key}) : super(key: key);

  @override
  State<IconsDemo> createState() => _IconsDemoState();
}

class _IconsDemoState extends State<IconsDemo> {
  List keys = [];

  Future<List<Map<String, IconData>>> getData(BuildContext context) async {
    final List<Map<String, IconData>> icons = [];
    final data = jsonDecode(
      await DefaultAssetBundle.of(context).loadString('packages/$packageName/lib/assets/fonts/selection.json'),
    )['icons'];
    for (final e in data) {
      icons.add({
        'ZdsIcons.${e['properties']['name']}':
            IconData(e['properties']['code'], fontFamily: 'zds-icons', fontPackage: packageName)
      });
      keys.add(GlobalKey());
    }

    return icons;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(context),
      builder: (BuildContext context, AsyncSnapshot<Object?> future) {
        if (future.connectionState == ConnectionState.done && future.data != null) {
          final List<Map<String, IconData>> icons = future.data as List<Map<String, IconData>>;
          return GridView.count(
              crossAxisCount: (MediaQuery.of(context).size.width / 100).floor(),
              padding: const EdgeInsets.symmetric(vertical: 32),
              children: [
                ...icons.map((e) {
                  return Column(
                    children: [
                      Icon(
                        e.values.first,
                        size: 48,
                      ).withPopOver(
                        (context) => Container(
                          constraints: const BoxConstraints(maxHeight: 300, maxWidth: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                          child: Text(e.keys.first),
                        ),
                      )
                    ],
                  );
                }).toList()
              ]);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
