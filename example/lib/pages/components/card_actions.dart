import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class CardActionsDemo extends StatelessWidget {
  const CardActionsDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ZdsCard(
              padding: EdgeInsets.zero,
              onTap: () {},
              child: const Column(
                children: [
                  SizedBox(height: 50),
                  ZdsCardActions(
                    children: [
                      ZdsTag(child: Text('Incomplete')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ZdsCard(
              padding: EdgeInsets.zero,
              onTap: () {},
              child: const Column(
                children: [
                  SizedBox(height: 50),
                  ZdsCardActions(
                    children: [
                      ZdsTag(
                        color: ZdsTagColor.primary,
                        child: Text('Pending Review'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ZdsCard(
              padding: EdgeInsets.zero,
              onTap: () {},
              child: const Column(
                children: [
                  SizedBox(height: 50),
                  ZdsCardActions(
                    children: [
                      ZdsLabel(
                        icon: Icons.calendar_today,
                        child: Text('Valid 5 days'),
                      ),
                      ZdsTag(
                        rounded: true,
                        prefix: Text('1'),
                        child: Text('High Priority'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ZdsCard(
              padding: EdgeInsets.zero,
              onTap: () {},
              child: const Column(
                children: [
                  SizedBox(height: 50),
                  ZdsCardActions(
                    children: [
                      Row(
                        children: [
                          ZdsLabel(
                            icon: ZdsIcons.schedule,
                            child: Text('30 min'),
                          ),
                          ZdsLabel(
                            icon: Icons.calendar_today,
                            child: Text('4 days'),
                          ),
                        ],
                      ),
                      ZdsTag(
                        rounded: true,
                        color: ZdsTagColor.error,
                        prefix: Text('U'),
                        child: Text('Urgent'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ZdsCardWithActions(
              actions: const [
                ZdsTag(child: Text('Incomplete')),
              ],
              children: [
                const CircleAvatar(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      'District Manager Monthly Walk',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '04/19/2021 03:35 PM',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ZdsColors.blueGrey),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SR-ROC-Rockford IL.00102',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ZdsColors.blueGrey),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            ZdsCardWithActions(
              direction: ZdsCardDirection.vertical,
              actions: const [
                ZdsTag(child: Text('Incomplete')),
              ],
              children: [
                Text(
                  'Lorem ipsum dolor sit amet consectetur adipiscing elit proin sagittis ipsum at velit bibendum non.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
