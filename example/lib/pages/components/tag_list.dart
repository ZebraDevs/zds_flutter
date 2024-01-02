import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class TagListDemo extends StatelessWidget {
  const TagListDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Horizontal').padding(8),
        ZdsCard(
          padding: EdgeInsets.zero,
          child: ZdsTagsList(
            direction: Axis.horizontal,
            items: [
              ZdsTag(
                customColor: Theme.of(context).colorScheme.primary,
                rounded: true,
                child: const Text('GM - Store'),
                onClose: () {},
              ),
              ZdsTag(
                customColor: Theme.of(context).colorScheme.primary,
                rounded: true,
                child: const Text('Store Message - Clothing'),
                onClose: () {},
              ),
              ZdsTag(
                customColor: Theme.of(context).colorScheme.primary,
                rounded: true,
                child: const Text('Team Leader - Clothing'),
                onClose: () {},
              ),
              ZdsTag(
                customColor: Theme.of(context).colorScheme.primary,
                rounded: true,
                child: const Text('GM - Second'),
                onClose: () {},
              ),
              ZdsTag(
                customColor: Theme.of(context).colorScheme.primary,
                rounded: true,
                child: const Text('Team Leader - Store'),
                onClose: () {},
              ),
            ],
          ),
        ),
        const Text('Vertical').padding(8),
        ZdsCard(
          padding: EdgeInsets.zero,
          child: ZdsTagsList(
            items: [
              ZdsTag(
                customColor: Theme.of(context).colorScheme.primary,
                rounded: true,
                child: const Text('GM - Store'),
                onClose: () {},
              ),
              ZdsTag(
                customColor: Theme.of(context).colorScheme.primary,
                rounded: true,
                child: const Text('Store Message - Clothing'),
                onClose: () {},
              ),
              ZdsTag(
                customColor: Theme.of(context).colorScheme.primary,
                rounded: true,
                child: const Text('Team Leader - Clothing'),
                onClose: () {},
              ),
              ZdsTag(
                customColor: Theme.of(context).colorScheme.primary,
                rounded: true,
                child: const Text('GM - Second'),
                onClose: () {},
              ),
              ZdsTag(
                customColor: Theme.of(context).colorScheme.primary,
                rounded: true,
                child: const Text('Team Leader - Store'),
                onClose: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
