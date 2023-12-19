import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({Key? key}) : super(key: key);

  @override
  _TextFieldDemoState createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  String? error;
  final noteController = TextEditingController();
  String? dropdownVal;

  @override
  void initState() {
    noteController.text = 'Lets get an early jump on the seasonal plannogram for this week. for this week.';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ZdsButton.filled(
            child: const Text('change dropdown'),
            onTap: () => setState(() {
              dropdownVal = 'P';
            }),
          ),
          const SizedBox(height: 16),
          ZdsDropdownList<String>(
            label: 'Dropdown label',
            options: [
              ZdsDropdownListItem(name: 'Approved', value: 'A'),
              ZdsDropdownListItem(name: 'Pending', value: 'P'),
              ZdsDropdownListItem(name: 'Declined', value: 'D'),
              ZdsDropdownListItem(name: 'Approved', value: 'K'),
            ],
            hint: 'hint',
            value: dropdownVal,
            onChange: (String option) {
              setState(() {
                dropdownVal = option;
              });
              debugPrint(option);
            },
          ),
          const SizedBox(height: 20),
          ZdsCard(
            child: ZdsResizableTextArea(
              enabled: false,
              controller: noteController,
              label: 'Responder Notes',
              maxLines: 100,
              footerText:
                  '09/09/22  @ 04:51pm    by: Ann Korgaard  by: Ann Korgaard  by: Ann Korgaard  by: Ann Korgaard',
            ),
          ),
          ZdsCard(
            child: ZdsResizableTextArea(
              textInputAction: TextInputAction.done,
              controller: noteController,
              label: 'Text Area ',
              maxLines: 100,
              footerText:
                  '09/09/22  @ 04:51pm    by: Ann Korgaard  by: Ann Korgaard  by: Ann Korgaard  by: Ann Korgaard',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: ZdsInputDecoration(
              labelText: 'Edit Filter Name',
              counterText: 'Character left: 255',
            ),
          ).paddingOnly(bottom: 16),
          TextField(
            maxLines: 10,
            decoration: ZdsInputDecoration(
              labelText: 'Message',
              counterText: 'Character left: 255',
            ),
          ).paddingOnly(bottom: 16),
          TextFormField(
            initialValue: 'Weekly Task',
            decoration: ZdsInputDecoration(
              mandatory: true,
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: '04/06/2021',
                  decoration: ZdsInputDecoration(
                    labelText: 'Start date',
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: '04/06/2021',
                  decoration: ZdsInputDecoration(
                    labelText: 'Due date',
                  ),
                ),
              ),
            ].divide(const SizedBox(width: 10)).toList(),
          ),
          TextFormField(
            decoration: ZdsInputDecoration.withNoLabel(
              prefixIcon: Icon(Icons.verified_user),
              suffixIcon: Icon(Icons.chevron_right),
            ),
          ),
          TextFormField(
            decoration: ZdsInputDecoration.withNoLabel(
              errorText: error,
            ),
          ),
          ZdsButton.muted(
            child: const Text('Validate'),
            onTap: () {
              setState(() {
                if (error == null) {
                  error = '';
                } else {
                  error = null;
                }
              });
            },
          ),
        ],
      ).content(),
    );
  }
}
