import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class ListTileWrapperDemo extends StatelessWidget {
  const ListTileWrapperDemo({super.key});

  static const tileCount = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: tileCount,
        padding: const EdgeInsets.all(14),
        itemBuilder: (context, index) {
          return ZdsListTileWrapper(
            top: index == 0,
            bottom: index == (tileCount - 1),
            child: ZdsListTile(
              title: Text('Title $index'),
              subtitle: Text('Subtitle $index'),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
