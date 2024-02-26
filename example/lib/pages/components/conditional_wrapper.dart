import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class ConditionalWrapperExample extends StatefulWidget {
  const ConditionalWrapperExample({Key? key}) : super(key: key);

  @override
  State<ConditionalWrapperExample> createState() => _ConditionalWrapperExampleState();
}

class _ConditionalWrapperExampleState extends State<ConditionalWrapperExample> {
  bool wrap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conditional Wrapper'),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                ZdsConditionalWrapper(
                  condition: wrap,
                  child: ZdsImages.calendar,
                  wrapperBuilder: (Widget child) {
                    return ZdsCard(child: child, variant: ZdsCardVariant.outlined);
                  },
                ).paddingOnly(top: 50),
                ZdsConditionalWrapper(
                  condition: wrap,
                  child: ZdsImages.sadZebra,
                  wrapperBuilder: (Widget child) {
                    return ZdsCard(child: child);
                  },
                ),
                ZdsConditionalWrapper(
                  condition: wrap,
                  child: ZdsButton.filled(
                    onTap: () => showToast(context),
                    child: const Text('Show Toast'),
                  ),
                  wrapperBuilder: (Widget child) {
                    return ZdsAbsorbPointer(
                      child: child,
                    );
                  },
                ),
              ].divide(SizedBox(height: 50)).toList(),
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Turn on conditional wrapping ->').padding(16),
              Switch(
                value: wrap,
                onChanged: (value) {
                  setState(() {
                    wrap = value;
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }

  void showToast(BuildContext context) {
    ScaffoldMessenger.of(context).showZdsToast(
      ZdsToast(
        title: const Text("I'm active!"),
        leading: const Icon(ZdsIcons.check_circle),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            icon: const Icon(ZdsIcons.close),
          ),
        ],
      ),
    );
  }
}
