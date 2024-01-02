import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class TagDemo extends StatelessWidget {
  const TagDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;
    return Scaffold(
      body: ZdsList(
        children: [
          ZdsCard(
            padding: EdgeInsets.zero,
            child: const ZdsListTile(
              trailing: ZdsTag(
                child: Text('Incomplete'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                color: ZdsTagColor.primary,
                child: const Text('Pending Review'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                rounded: true,
                prefix: const Text('U'),
                color: ZdsTagColor.error,
                child: const Text('Urgent'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                rounded: true,
                prefix: const Text('1'),
                color: ZdsTagColor.alert,
                child: const Text('High Priority'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                rounded: true,
                prefix: const Text('2'),
                color: ZdsTagColor.secondary,
                child: const Text('Medium Priority'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                rounded: true,
                prefix: const Text('3'),
                color: ZdsTagColor.success,
                child: const Text('Low Priority'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: const ZdsListTile(
              trailing: ZdsTag(
                filled: true,
                child: Text('Default'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                filled: true,
                color: ZdsTagColor.error,
                child: const Text('Urgent'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                filled: true,
                color: ZdsTagColor.alert,
                child: const Text('High Priority'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: const ZdsListTile(
              trailing: ZdsTag(
                filled: true,
                child: Text('Primary'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                filled: true,
                color: ZdsTagColor.primary,
                child: const Text('Medium Priority'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                filled: true,
                color: ZdsTagColor.success,
                child: const Text('Approved'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                filled: true,
                customColor: zetaColors.cool,
                child: const Text('Custom onClose'),
                onClose: () {},
              ),
            ),
          ),
          // The following two tags are meant to show tags that enable users' big font settings
          ZdsCard(
            padding: EdgeInsets.zero,
            child: const ZdsListTile(
              trailing: ZdsTag(
                unrestrictedSize: true,
                child: Text('Unbounded'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                unrestrictedSize: true,
                onClose: () {},
                child: const Text('Unbound+btn'),
              ),
            ),
          ),
          // New Tag variants from https://jira.zebra.com/browse/ZU-92 - 30/03/2022 J
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                rectangular: true,
                color: ZdsTagColor.secondary,
                child: const Text('Give away'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                rectangular: true,
                color: ZdsTagColor.secondary,
                child: const Text('Additional'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                rectangular: true,
                color: ZdsTagColor.success,
                prefix: Icon(Icons.check, size: 18, color: zetaColors.green),
                child: const Text(
                  'Approved',
                ),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                rectangular: true,
                color: ZdsTagColor.secondary,
                prefix: Icon(Icons.hourglass_bottom, size: 18, color: Theme.of(context).colorScheme.secondary),
                child: const Text('Pending'),
              ),
            ),
          ),
          ZdsCard(
            padding: EdgeInsets.zero,
            child: ZdsListTile(
              trailing: ZdsTag(
                rectangular: true,
                color: ZdsTagColor.error,
                prefix: Icon(Icons.close, size: 18, color: zetaColors.red),
                child: const Text('Declined'),
              ),
            ),
          ),
        ].divide(const SizedBox(height: 16)).toList(),
      ),
    );
  }
}
