import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class NestedFlowDemo extends StatelessWidget {
  const NestedFlowDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ZdsList(
        children: [
          ZdsButton(
            onTap: () => showFlow(context).then((value) => print(value)),
            child: const Text('Show Nested Flow'),
          ),
          const Text(
            'Navigate through the nested flow and see how the back button works. Result will be printed to the console.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ].divide(const SizedBox(height: 20)).toList(),
      ),
    );
  }

  Future<dynamic> showFlow(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 320,
            width: 320,
            child: ZdsCard(
              padding: EdgeInsets.zero,
              child: ZdsNestedFlow(
                child: NestedPage(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NestedPage extends StatelessWidget {
  const NestedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? BackButton()
            : CloseButton(
                onPressed: () {
                  ZdsNestedFlow.of(context).pop();
                },
              ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ZdsButton.filled(
              child: Text('Next'),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => NestedPage())).then(
                  (value) {
                    print(value);
                  },
                );
              },
            ),
          ),
          Center(
            child: ZdsButton.filled(
              child: Text('Navigator.of(context).pop()'),
              onTap: () {
                Navigator.of(context).pop(DateTime.now());
              },
            ),
          ),
          Center(
            child: ZdsButton.filled(
              child: Text('ZdsNestedFlow.of(context).pop()'),
              onTap: () {
                ZdsNestedFlow.of(context).pop(DateTime.now());
              },
            ),
          ),
        ],
      ),
    );
  }
}
