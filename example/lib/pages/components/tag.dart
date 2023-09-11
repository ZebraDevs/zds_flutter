import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class TagDemo extends StatelessWidget {
  const TagDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ZdsListTile(
                trailing: ZdsTag(
                  child: Text('Incomplete'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  color: ZdsTagColor.primary,
                  child: const Text('Pending Review'),
                ),
              ),
              const SizedBox(height: 20),
              ZdsListTile(
                trailing: ZdsTag(
                  rounded: true,
                  prefix: const Text('U'),
                  color: ZdsTagColor.error,
                  child: const Text('Urgent'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  rounded: true,
                  prefix: const Text('1'),
                  color: ZdsTagColor.alert,
                  child: const Text('High Priority'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  rounded: true,
                  prefix: const Text('2'),
                  color: ZdsTagColor.secondary,
                  child: const Text('Medium Priority'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  rounded: true,
                  prefix: const Text('3'),
                  color: ZdsTagColor.success,
                  child: const Text('Low Priority'),
                ),
              ),
              const SizedBox(height: 20),
              const ZdsListTile(
                trailing: ZdsTag(
                  filled: true,
                  child: Text('Default'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  filled: true,
                  color: ZdsTagColor.error,
                  child: const Text('Urgent'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  filled: true,
                  color: ZdsTagColor.alert,
                  child: const Text('High Priority'),
                ),
              ),
              const ZdsListTile(
                trailing: ZdsTag(
                  filled: true,
                  child: Text('Primary'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  filled: true,
                  color: ZdsTagColor.primary,
                  child: const Text('Medium Priority'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  filled: true,
                  color: ZdsTagColor.success,
                  child: const Text('Approved'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  filled: true,
                  customColor: ZdsColors.blueGrey,
                  child: const Text('Custom onClose'),
                  onClose: () {},
                ),
              ),
              // The following two tags are meant to show tags that enable users' big font settings
              const ZdsListTile(
                trailing: ZdsTag(
                  unrestrictedSize: true,
                  child: Text('Unbounded'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  unrestrictedSize: true,
                  onClose: () {},
                  child: const Text('Unbound+btn'),
                ),
              ),
              // New Tag variants from https://jira.zebra.com/browse/ZU-92 - 30/03/2022 J
              ZdsListTile(
                trailing: ZdsTag(
                  rectangular: true,
                  color: ZdsTagColor.secondary,
                  child: const Text('Give away'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  rectangular: true,
                  color: ZdsTagColor.secondary,
                  child: const Text('Additional'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  rectangular: true,
                  color: ZdsTagColor.success,
                  prefix: const Icon(Icons.check, size: 18),
                  child: const Text('Approved'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  rectangular: true,
                  color: ZdsTagColor.secondary,
                  prefix: const Icon(Icons.hourglass_bottom, size: 18),
                  child: const Text('Pending'),
                ),
              ),
              ZdsListTile(
                trailing: ZdsTag(
                  rectangular: true,
                  color: ZdsTagColor.error,
                  prefix: const Icon(Icons.close, size: 18),
                  child: const Text('Declined'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
