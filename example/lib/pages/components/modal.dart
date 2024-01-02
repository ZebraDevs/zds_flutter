import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class ModalDemo extends StatelessWidget {
  const ModalDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZdsButton.muted(
              child: const Text('Name modal'),
              onTap: () {
                showDialog(
                  builder: (BuildContext context) {
                    return ZdsModal(
                      actions: [
                        ZdsButton.muted(
                          child: const Text('Cancel'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ZdsButton(
                          child: const Text('Save'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextField(
                          decoration: ZdsInputDecoration(
                            labelText: 'Edit Walk Name',
                            counter: const Text('Character left: 255'),
                          ),
                        ),
                      ),
                    );
                  },
                  context: context,
                );
              },
            ),
            ZdsButton.muted(
              child: const Text('Expansion modal'),
              onTap: () {
                showDialog(
                  builder: (BuildContext context) {
                    return ZdsModal(
                      padding: EdgeInsets.zero,
                      actions: [
                        ZdsButton.muted(
                          child: const Text('Cancel'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ZdsButton(
                          child: const Text('Save'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      child: Column(
                        children: [
                          ZdsExpansionTile(
                            initiallyExpanded: true,
                            title: const Text('Covid Survey'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Emergency Form 2', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 3', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 19', style: Theme.of(context).textTheme.bodyMedium).space(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                            child: TextField(
                              decoration: ZdsInputDecoration(
                                labelText: 'Question Tag and Response',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  context: context,
                );
              },
            ),
            ZdsButton.muted(
              child: const Text('Input dialog'),
              onTap: () {
                showDialog(
                  builder: (BuildContext context) {
                    return ZdsInputDialog(
                      title: 'Save Filter',
                      hint: 'Enter filter name',
                      primaryAction: 'Save',
                      secondaryAction: 'Cancel',
                      characterCount: 30,
                      onValidate: (value) async {
                        if (value.isEmpty) {
                          return 'This field is mandatory';
                        } else {
                          return null;
                        }
                      },
                    );
                  },
                  context: context,
                );
              },
            ),
            ZdsButton.muted(
              child: const Text('Multiple Expansion modal'),
              onTap: () {
                showDialog(
                  builder: (BuildContext context) {
                    return ZdsModal(
                      padding: EdgeInsets.zero,
                      actions: [
                        ZdsButton.muted(
                          child: const Text('Cancel'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ZdsButton(
                          child: const Text('Save'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      child: Column(
                        children: [
                          ZdsExpansionTile(
                            initiallyExpanded: true,
                            title: const Text('Form Instance Creation Date'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Emergency Form 2', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 3', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 19', style: Theme.of(context).textTheme.bodyMedium).space(),
                              ],
                            ),
                          ),
                          ZdsExpansionTile(
                            title: const Text('Form Category'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Emergency Form 2', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 3', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 19', style: Theme.of(context).textTheme.bodyMedium).space(),
                              ],
                            ),
                          ),
                          ZdsExpansionTile(
                            title: const Text('Question Tag and Response'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Emergency Form 2', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 3', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 19', style: Theme.of(context).textTheme.bodyMedium).space(),
                              ],
                            ),
                          ),
                          ZdsExpansionTile(
                            title: const Text('Form Instance Creator Name'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Emergency Form 2', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 3', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 19', style: Theme.of(context).textTheme.bodyMedium).space(),
                              ],
                            ),
                          ),
                          ZdsExpansionTile(
                            title: const Text('Form Unique Identifier'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Emergency Form 2', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 3', style: Theme.of(context).textTheme.bodyMedium).space(8),
                                Text('Emergency Form 19', style: Theme.of(context).textTheme.bodyMedium).space(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  context: context,
                );
              },
            ),
            ZdsButton.muted(
              child: const Text('Textboxes modal'),
              onTap: () {
                showDialog(
                  builder: (BuildContext context) {
                    return ZdsModal(
                      usesKeyboard: true,
                      actions: [
                        ZdsButton.muted(
                          child: const Text('Cancel'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ZdsButton(
                          child: const Text('Save'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: TextField(
                              decoration: ZdsInputDecoration(
                                labelText: 'Text box 1',
                                counter: const Text('Character left: 255'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: TextField(
                              decoration: ZdsInputDecoration(
                                labelText: 'Text box 2',
                                counter: const Text('Character left: 255'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: TextField(
                              decoration: ZdsInputDecoration(
                                labelText: 'Text box 3',
                                counter: const Text('Character left: 255'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  context: context,
                );
              },
            ),
            ZdsButton.muted(
              child: const Text('Icon modal'),
              onTap: () {
                showDialog(
                  builder: (BuildContext context) {
                    return ZdsModal(
                      icon: ZdsIcons.indicator_alert,
                      actions: [
                        ZdsButton(
                          child: const Text('Ok'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      child: const Padding(padding: EdgeInsets.only(top: 16), child: Text('The icon can be changed.')),
                    );
                  },
                  context: context,
                );
              },
            ),
            ZdsButton.muted(
              child: const Text('Aligned dialog'),
              onTap: () {
                showDialog(
                  builder: (BuildContext context) {
                    return ZdsModal(
                      icon: ZdsIcons.chevron_left,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      actions: [
                        ZdsButton(
                          child: const Text('Ok'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      child: const Padding(padding: EdgeInsets.only(top: 16), child: Text('Slide to the left!')),
                    );
                  },
                  context: context,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
