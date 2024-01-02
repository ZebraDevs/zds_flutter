import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class ColorUtilsDemo extends StatefulWidget {
  const ColorUtilsDemo({Key? key}) : super(key: key);

  @override
  State<ColorUtilsDemo> createState() => _ColorUtilsDemoState();
}

class _ColorUtilsDemoState extends State<ColorUtilsDemo> {
  final TextEditingController controller = TextEditingController();
  late Color color;

  @override
  void initState() {
    super.initState();

    color = getRandomColorFromTheme(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: ZdsInputDecoration(labelText: 'Input text as seed'),
              controller: controller,
              onSubmitted: (value) => setState(() => color = getRandomColorFromTheme(value)),
            ),
            ZdsButton.filled(
              child: const Text('Generate random color'),
              onTap: () => setState(() => color = getRandomColorFromTheme(controller.text)),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              color: color,
              height: 200,
              width: 200,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  '#${color.toString().split('0xff').last.replaceAll(')', '').toUpperCase()}',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(color: color.onColor),
                ),
              ),
            ),
          ],
        ).paddingOnly(left: 24, right: 24),
      ),
    );
  }
}
