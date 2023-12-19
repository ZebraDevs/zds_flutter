import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class IndexDemo extends StatelessWidget {
  const IndexDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            ZdsListTile(
              leading: ZdsIndex(
                child: Text('2'),
                color: Zeta.of(context).colors.blue,
              ),
              title: Text('Showcase Extravaganza'),
            ),
            ZdsListTile(
              leading: ZdsIndex(
                child: Text('2'),
                color: Zeta.of(context).colors.purple,
              ),
              title: Text('Showcase Extravaganza'),
            ),
            const ZdsListTile(
              leading: ZdsIndex(
                child: Text('2'),
              ),
              title: Text('Showcase Extravaganza'),
            ),
            ZdsListTile(
              title: Row(
                children: [
                  Text(
                    'Priority',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(width: 6),
                  ZdsIndex(
                    color: Theme.of(context).colorScheme.error,
                    child: const Text('U'),
                  ),
                ],
              ),
              trailing: Icon(
                ZdsIcons.chevron_right,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
