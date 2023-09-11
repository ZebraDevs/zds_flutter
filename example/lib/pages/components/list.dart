import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class ListDemo extends StatelessWidget {
  const ListDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ZdsListGroup(
            headerLabel: const Text('Search for title'),
            headerActions: [
              InkWell(
                onTap: () {},
                child: const Row(
                  children: [Icon(ZdsIcons.add), Text('Add Tile')],
                ),
              ),
            ],
            items: [
              ListView.separated(
                separatorBuilder: (_, i) => const Divider(),
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (_, index) {
                  return ZdsListTile(
                    onTap: () {},
                    title: const Text('View summary'),
                    trailing: const Icon(ZdsIcons.chevron_right),
                  );
                },
              )
            ],
          ),
          ZdsHorizontalList(
            caption: const Text('Your Shift'),
            children: [
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
            ],
          ),
          ZdsHorizontalList(
            caption: const Text(
              'Your Shift',
            ).font(size: 15),
            children: [
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
            ],
          ),
          ZdsHorizontalList(
            children: [
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
            ],
          ),
          ZdsHorizontalList(
            caption: const Text('Reduced Height List'),
            isReducedHeight: true,
            children: [
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
              const SizedBox(width: 160, height: 220).backgroundColor(Colors.red).padding(10),
            ],
          ),
        ],
      ),
    );
  }
}
