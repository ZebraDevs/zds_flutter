import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class SpeedScrollableListDemo extends StatelessWidget {
  const SpeedScrollableListDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ZdsSpeedScrollableListItemGroup(itemGroup: 'A', children: [
        ZdsListTile(title: Text('Aaron')),
        ZdsListTile(title: Text('Aaron')),
        ZdsListTile(title: Text('Aaron')),
        ZdsListTile(title: Text('Aaron')),
        ZdsListTile(title: Text('Aaron')),
      ]),
      ZdsSpeedScrollableListItemGroup(itemGroup: 'B', children: [
        ZdsListTile(title: Text('Bernard')),
        ZdsListTile(title: Text('Bernard')),
        ZdsListTile(title: Text('Bernard')),
        ZdsListTile(title: Text('Bernard')),
        ZdsListTile(title: Text('Bernard')),
      ]),
      ZdsSpeedScrollableListItemGroup(itemGroup: 'C', children: [
        ZdsListTile(title: Text('Carlos')),
        ZdsListTile(title: Text('Carlos')),
        ZdsListTile(title: Text('Carlos')),
        ZdsListTile(title: Text('Carlos')),
        ZdsListTile(title: Text('Carlos')),
        ZdsListTile(title: Text('Carlos')),
        ZdsListTile(title: Text('Carlos')),
      ]),
      ZdsSpeedScrollableListItemGroup(itemGroup: 'D', children: [
        ZdsListTile(title: Text('Dennis')),
        ZdsListTile(title: Text('Dennis')),
        ZdsListTile(title: Text('Dennis')),
        ZdsListTile(title: Text('Dennis')),
        ZdsListTile(title: Text('Dennis')),
        ZdsListTile(title: Text('Dennis')),
        ZdsListTile(title: Text('Dennis')),
      ]),
      ZdsSpeedScrollableListItemGroup(itemGroup: 'T', children: [
        ZdsListTile(title: Text('Toby')),
        ZdsListTile(title: Text('Toby')),
        ZdsListTile(title: Text('Toby')),
        ZdsListTile(title: Text('Toby')),
        ZdsListTile(title: Text('Toby')),
        ZdsListTile(title: Text('Toby')),
        ZdsListTile(title: Text('Toby')),
        ZdsListTile(title: Text('Toby')),
        ZdsListTile(title: Text('Toby')),
        ZdsListTile(title: Text('Toby')),
        ZdsListTile(title: Text('Toby')),
        ZdsListTile(title: Text('Toby')),
      ]),
    ];
    return ZdsSpeedScrollableList(items: items, itemGroups: ZdsSpeedSlider.defaultItems);
  }
}
