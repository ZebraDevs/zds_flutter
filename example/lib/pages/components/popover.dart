import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class PopOverDemo extends StatefulWidget {
  const PopOverDemo({Key? key}) : super(key: key);

  @override
  _PopOverDemoState createState() => _PopOverDemoState();
}

class _PopOverDemoState extends State<PopOverDemo> {
  final GlobalKey button1Key = GlobalKey();
  final GlobalKey button2Key = GlobalKey();
  final GlobalKey button3Key = GlobalKey();
  final GlobalKey button4Key = GlobalKey();
  final GlobalKey button5Key = GlobalKey();
  final GlobalKey button6Key = GlobalKey();

  final EdgeInsets _contentPadding = const EdgeInsets.all(20);

  void _showPopover({required GlobalKey key, Widget? child, BoxConstraints? constraints}) {
    showZdsPopOver(
      context: key.currentContext ?? context,
      builder: (BuildContext context) => Container(
        constraints: constraints ?? const BoxConstraints(maxHeight: 300, maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: child ??
            const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZdsAppBar(
        title: const Text('Popover Demo'),
        icon: const Icon(ZdsIcons.launch).withPopOver((context) => const FlutterLogo().paddingInsets(_contentPadding)),
        actions: [
          ZdsPopOverIconButton(
            icon: const Icon(ZdsIcons.info),
            popOverBuilder: (context) {
              return const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.')
                  .paddingInsets(_contentPadding);
            },
          ),
          ZdsPopOverIconButton(
            icon: const Icon(ZdsIcons.sort),
            backgroundColor: Zeta.of(context).colors.red,
            popOverBuilder: (context) {
              return Container(
                child: const Text('Lorem ipsum dolor sit amet.').textStyle(
                  Theme.of(context).textTheme.bodyLarge?.copyWith(color: Zeta.of(context).colors.red.onColor),
                ),
              ).paddingInsets(_contentPadding);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ZdsButton.text(
                key: button1Key,
                child: const Text('Tap me'),
                onTap: () {
                  _showPopover(key: button1Key);
                },
              ),
              ZdsButton.text(
                key: button2Key,
                child: const Text('Tap me'),
                onTap: () {
                  _showPopover(key: button2Key);
                },
              ),
            ],
          ),
          Column(
            children: [
              ZdsButton.text(
                key: button3Key,
                child: const Text('Tap me'),
                onTap: () {
                  _showPopover(key: button3Key);
                },
              ),
              const SizedBox(height: 60),
              ZdsButton.text(
                key: button4Key,
                child: const Text('Tap me'),
                onTap: () {
                  _showPopover(key: button4Key);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ZdsButton.text(
                key: button5Key,
                child: const Text('Tap me'),
                onTap: () {
                  _showPopover(key: button5Key);
                },
              ),
              ZdsButton.text(
                key: button6Key,
                child: const Text('Tap me'),
                onTap: () {
                  _showPopover(key: button6Key);
                },
              ),
            ],
          )
        ],
      ).paddingInsets(_contentPadding),
    );
  }
}
