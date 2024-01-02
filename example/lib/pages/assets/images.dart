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
        'name': 'ZdsImages.clock',
        'image': ZdsImages.clock,
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
        'name': 'ZdsImages.darkMode',
        'image': ZdsImages.darkMode,
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
        'name': 'ZdsImages.lightMode',
        'image': ZdsImages.lightMode,
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
        'name': 'ZdsImages.lightMode',
        'image': ZdsImages.lightMode,
      },
      {
        'name': 'ZdsImages.darkMode',
        'image': ZdsImages.darkMode,
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
      {
        'name': 'ZdsImages.systemMode',
        'image': ZdsImages.systemMode,
      },
    ];

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: images
              .map((e) => ImgBox(img: e['image'], name: e['name']))
              .toList()
              .divide(const SizedBox(height: 32))
              .toList(),
        ),
      ),
    );
  }
}

class ImgBox extends StatelessWidget {
  final Widget img;
  final String name;
  const ImgBox({Key? key, required this.img, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      img,
      const SizedBox(height: 12),
      Text(name),
      const SizedBox(height: 32),
    ]);
  }
}
