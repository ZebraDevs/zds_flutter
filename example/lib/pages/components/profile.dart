import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class ProfileDemo extends StatelessWidget {
  const ProfileDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(ZdsIcons.close),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: const Text('Close'),
      ),
      body: Column(
        children: [
          ZdsProfile(
            avatar: ZdsAvatar(
              image: Image.network(
                'https://www.zebra.com/content/dam/zebra_dam/global/graphics/logos/zebra-logo-black-stacked.png',
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            nameText: const Text('Jason Davis'),
            jobTitleText: const Text('Store Manager'),
            action: ZdsButton.text(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(
                    ZdsIcons.edit,
                    size: 18,
                  ).paddingOnly(right: 4),
                  const Text('Edit'),
                ],
              ),
            ),
          ).padding(24),
        ],
      ),
    );
  }
}
