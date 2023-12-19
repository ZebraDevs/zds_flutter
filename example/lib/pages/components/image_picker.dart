import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class ImagePickerDemo extends StatelessWidget {
  const ImagePickerDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ImagePicker(
              icon: Icon(
                ZdsIcons.camera,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              onChange: (path) {
                debugPrint(path);
              },
            ),
            ImagePicker(
              size: 48,
              showBorder: false,
              backgroundColor: const Color.fromRGBO(0, 122, 186, 0.1),
              icon: Icon(
                ZdsIcons.camera,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              onChange: (path) {
                debugPrint(path);
              },
            ),
          ],
        ),
      ),
    );
  }
}
