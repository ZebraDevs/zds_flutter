import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class DatePickerDemo extends StatefulWidget {
  const DatePickerDemo({Key? key}) : super(key: key);

  @override
  _DatePickerDemoState createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<DatePickerDemo> {
  late ZdsValueController<DateTime> _controller;
  late ZdsValueController<DateTime> _startController;
  late ZdsValueController<DateTime> _endController;
  DateTime? tileInitialDate;
  DateTime? tileFinalDate;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = ZdsValueController<DateTime>();
    _startController = ZdsValueController<DateTime>();
    _endController = ZdsValueController<DateTime>();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZdsList(
      padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 16),
      children: [
        ZdsDateTimePicker(
          emptyLabel: 'select date',
          format: 'MMM dd, yyyy',
          helpText: 'Help text example',
          minDate: DateTime.now(),
          inputDecoration: ZdsInputDecoration(
            labelText: 'Date',
          ),
          onChange: (dateTime) {},
          startDayOfWeek: 5,
          okClickText: 'ok',
          cancelClickText: 'cancel',
        ),
        ZdsDateTimePicker(
          emptyLabel: 'select date',
          format: 'MMM dd, yyyy',
          minDate: DateTime.now(),
          helpText: 'Help text example',
          controller: _controller,
          inputDecoration: ZdsInputDecoration(
            labelText: 'Optional Date',
            suffixIcon: _controller.value != null
                ? IconButton(
                    icon: const Icon(
                      ZdsIcons.close_circle,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value = null;
                      });
                    },
                  )
                : null,
          ),
          onChange: (dateTime) {
            setState(() {});
          },
        ),
        ZdsDateTimePicker(
          emptyLabel: 'select time',
          format: 'hh:mm a',
          textAlign: TextAlign.center,
          minDate: DateTime.now(),
          mode: DateTimePickerMode.time,
        ),
        ZdsDateTimePicker(
          emptyLabel: 'time picker with interval',
          format: 'hh:mm a',
          textAlign: TextAlign.center,
          minDate: DateTime.now(),
          mode: DateTimePickerMode.time,
          interval: 15,
        ),
        ZdsCard(
          padding: EdgeInsets.zero,
          child: ZdsListTile(
            title: const Text('Build Time'),
            trailing: ZdsDateTimePicker(
              emptyLabel: 'select date & time',
              format: 'MMM dd, yyyy hh:mm a',
              textAlign: TextAlign.end,
              minDate: DateTime.now(),
              mode: DateTimePickerMode.dateAndTime,
            ),
          ),
        ),
        const Text('Example with controllers and custom validation:').paddingOnly(top: 8),
        ZdsDateRangePickerTile(
          initialDate: tileInitialDate,
          finalDate: tileFinalDate,
          onInitialDateChanged: (selectedDate) => tileInitialDate = selectedDate,
          onFinalDateChanged: (selectedDate) => tileFinalDate = selectedDate,
          initialDateController: _startController,
          finalDateController: _endController,
          errorMessage: 'Invalid range entered',
        ),
        const Text('Example using built-in form validation:').paddingOnly(top: 8),
        Form(
          key: formKey,
          child: ZdsDateRangePickerTileForm(
            validator: (value) => value.isValid == true || value.isIncomplete ? null : 'Please enter a valid value',
          ),
        ),
        ZdsButton(
          child: const Text('Clear range values'),
          onTap: () {
            formKey.currentState!.reset();
            _startController.value = null;
            _endController.value = null;
          },
        )
      ].divide(const SizedBox(height: 16)).toList(),
    );
  }
}
