import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class ImagesDemo extends StatelessWidget {
  const ImagesDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List images = [
      {
        'name': 'ZdsImages.calendar',
        'image': ZdsImages.calendar,
      },
      {
        'name': 'ZdsImages.chat',
        'image': ZdsImages.chat,
      },
      {
        'name': 'ZdsImages.cloudFail',
        'image': ZdsImages.cloudFail,
      },
      {
        'name': 'ZdsImages.completedTasks',
        'image': ZdsImages.completedTasks,
      },
      {
        'name': 'ZdsImages.connectionDead',
        'image': ZdsImages.connectionDead,
      },
      {
        'name': 'ZdsImages.emptyBox',
        'image': ZdsImages.emptyBox,
      },
      {
        'name': 'ZdsImages.internetFail',
        'image': ZdsImages.internetFail,
      },
      {
        'name': 'ZdsImages.loadFail',
        'image': ZdsImages.loadFail,
      },
      {
        'name': 'ZdsImages.map',
        'image': ZdsImages.map,
      },
      {
        'name': 'ZdsImages.notes',
        'image': ZdsImages.notes,
      },
      {
        'name': 'ZdsImages.notifications',
        'image': ZdsImages.notifications,
      },
      {
        'name': 'ZdsImages.sadZebra',
        'image': ZdsImages.sadZebra,
      },
      {
        'name': 'ZdsImages.search',
        'image': ZdsImages.search,
      },
      {
        'name': 'ZdsImages.serverFail',
        'image': ZdsImages.serverFail,
      },
      {
        'name': 'ZdsImages.sleepingZebra',
        'image': ZdsImages.sleepingZebra,
      },
    ];

    return GridView.count(
      crossAxisCount: (MediaQuery.of(context).size.width / 200).floor(),
      padding: const EdgeInsets.symmetric(vertical: 32),
      mainAxisSpacing: 40,
      crossAxisSpacing: 40,
      children: [
        ...images.map((e) {
          return Column(children: [
            SizedBox(width: 140, height: 140, child: e['image']),
            Row(
              children: [
                Expanded(
                  child: FittedBox(fit: BoxFit.scaleDown, child: Text(e['name'])),
                ),
              ],
            ),
          ]);
        }).toList()
      ],
    );
  }
}

class ImgBox extends StatelessWidget {
  final Widget img;
  final String name;

  const ImgBox({Key? key, required this.img, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 144, height: 144, child: Column(children: [img, Text(name)]));
  }
}
