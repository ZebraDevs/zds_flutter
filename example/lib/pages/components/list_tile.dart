import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zds_flutter/zds_flutter.dart';

class ListTileDemo extends StatelessWidget {
  const ListTileDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);

    return Scaffold(
      body: ZdsList(
        children: [
          const SizedBox(height: 20),
          ZdsSelectableListTile(
            title: const Text('Urgent'),
            subTitle: const Text('32 hours available'),
            selected: true,
            trailing: ZdsIndex(color: zeta.colors.red, child: const Text('U')),
            onTap: () {},
          ),
          ZdsSelectableListTile(
            title: const Text('High'),
            trailing: ZdsIndex(color: zeta.colors.orange, child: const Text('1')),
            onTap: () {},
          ),
          ZdsSelectableListTile(
            title: const Text('Medium'),
            trailing: ZdsIndex(color: zeta.colors.teal, child: const Text('2')),
            onTap: () {},
          ),
          ZdsSelectableListTile(
            title: const Text('Low'),
            trailing: ZdsIndex(color: zeta.colors.green, child: const Text('3')),
            onTap: () {},
          ),
          ZdsSelectableListTile.checkable(
            title: const Text('Checkable unselected'),
            onTap: () {},
          ),
          ZdsSelectableListTile.checkable(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Checkable selected'),
                Text(
                  'Checkable unselected',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            ),
            selected: true,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          ZdsListTile(
            title: const Text('View summary'),
            trailing: TextFormField(
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                hintText: 'First Name',
              ),
            ),
          ),
          ZdsListTile(
            leading: const Icon(ZdsIcons.camera),
            title: const Text('View summary'),
            subtitle: const Text('subtitle'),
            trailing: Switch(
              onChanged: (_) {},
              value: true,
            ),
          ),
          ZdsListGroup(
            headerLabel: const Text('Search for title, description and unique ID'),
            items: [
              const ZdsListTile(
                title: Text('View summary'),
                subtitle: Text('subtitle'),
                trailing: Icon(ZdsIcons.chevron_right),
              ),
              ZdsListTile(
                leading: const Icon(ZdsIcons.search),
                title: const Text('With onTap'),
                trailing: const Icon(ZdsIcons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          const ZdsListTile(
            leading: Icon(ZdsIcons.pdf),
            title: Text('View summary'),
            trailing: Icon(
              ZdsIcons.chevron_right,
            ),
          ),
          ZdsListTile(
            leading: IconButton(
              icon: const Icon(ZdsIcons.pdf),
              onPressed: () {},
            ),
            title: const Text('This is a very very very long loooong list tile'),
            trailing: const Icon(
              ZdsIcons.chevron_right,
            ),
          ),
          ZdsListTile(
            leading: IconButton(
              icon: const Icon(ZdsIcons.pdf),
              onPressed: () {},
            ),
            title: const Text('With icon button normal'),
            trailing: IconButton(
              onPressed: () {},
              iconSize: 24,
              icon: const Icon(
                ZdsIcons.chevron_right,
              ),
            ),
          ),
          ZdsListGroup(
            items: [
              ZdsListTile(
                title: Text(
                  'Team Leader - Store',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                trailing: Icon(
                  ZdsIcons.check,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const ZdsListTile(
                title: Text('View summary'),
                trailing: Icon(ZdsIcons.check),
              ),
              const ZdsListTile(
                title: Text('View summary'),
                trailing: Icon(ZdsIcons.check),
              ),
            ],
          ),
          ZdsListTile(
            title: Text(
              'Team Leader - Store',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            trailing: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ZdsCard(
            child: ZdsPropertiesList(
              direction: ZdsPropertiesListDirection.vertical,
              properties: {
                'Das URL': '',
              },
            ),
          ),
          ZdsCard(
            child: ZdsPropertiesList(
              direction: ZdsPropertiesListDirection.vertical,
              properties: {
                'Application URL': 'None',
              },
            ),
          ),
          ZdsListTile(
            title: const ZdsPropertiesList(
              direction: ZdsPropertiesListDirection.vertical,
              properties: {
                'Domain Key': 'Please add',
              },
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
          ),
          const ZdsListTile(
            title: Text('View summary'),
            trailing: Icon(ZdsIcons.check),
          ),
          const ZdsListTile(
            title: Text('View summary'),
            trailing: Icon(ZdsIcons.chevron_right),
          ),
          const ZdsListTile(
            leading: Icon(ZdsIcons.pdf),
            title: Text('Unique ID'),
            trailing: Text('Unique ID'),
          ),
          const ZdsListTile(
            leading: Icon(ZdsIcons.pdf),
            title: Text('View type'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('My walks'),
                SizedBox(width: 10),
                Icon(ZdsIcons.chevron_right),
              ],
            ),
          ),
          ZdsListTile(
            onTap: () {},
            title: const Text('Notes'),
            bottom: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• This is a bullet point list'),
                      Text('• Next point'),
                      Text('• More information'),
                    ],
                  ).textStyle(Theme.of(context).textTheme.bodyLarge),
                ),
              ],
            ),
          ),
          ZdsListTile(
            onTap: () {},
            contentPadding: kZdsListTileTheme.contentPadding.copyWith(left: 0),
            title: const Text('Not scheduled today'),
            leading: Container(
              width: 6,
              height: 65,
              color: zeta.colors.red,
            ),
          ),
          ZdsNotificationTile(
            dateLabel: 'MMM dd, yyyy hh:mm a',
            content: 'PTO Request approved for Mon at Jan 11 at 11:00 am',
          ),
          ZdsNotificationTile(
            onTap: () {},
            dateLabel: getNotificationDate(),
            content: 'Meeting with Jordan Smith at Jan 11 at 11:00 am',
            leadingData: Icon(
              ZdsIcons.lightbulb,
              color: zeta.colors.orange,
              size: 16,
            ),
          ),
          ZdsFieldsListTile(
            shrink: false,
            title: const Text(
              'Title of the Project - 0001 Client > Zone 6_thiscan go upwards of two or three lines_ Coporateconfiguration',
            ),
            fields: const [
              TileField(
                start: Text('Start/End'),
                end: Text('07/05/2021 - 07/05/2021'),
              ),
              TileField(
                start: Text('Approval Date'),
                end: Text('07/06/2021 16;45 PST'),
              ),
              TileField(
                start: Text('Status?'),
                end: Text('N/A'),
              ),
            ],
            footnote: const Text(
              'You have exceeded your balance. You will be eligible to take more time off after March 1.',
            ),
            data: 'Any object',
            onTap: (String? data) {
              debugPrint(data ?? '');
            },
          ),
          ZdsFieldsListTile(
            title: Row(
              children: [
                Icon(
                  ZdsIcons.task,
                  color: Theme.of(context).primaryColor,
                  size: 25,
                ).paddingOnly(right: 10),
                Text(
                  'Manual Task Survey 2',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            fieldsEndTextStyle: Theme.of(context).textTheme.bodyLarge,
            fields: const [
              TileField(
                start: Text('Execution level'),
                end: Text('Store'),
              ),
              TileField(
                start: Text('Assigned'),
                end: Text('Store Manager'),
              ),
              TileField(
                start: Text('Department'),
                end: Text('Store'),
              ),
              TileField(
                start: Text('Type'),
                end: Text('System'),
              ),
            ],
            data: 'Any object',
            onTap: (String? data) {},
          ),
          ZdsFieldsListTile(
            startFieldFlexFactor: 2,
            fieldsStartTextStyle: Theme.of(context).textTheme.bodyMedium,
            fieldsEndTextStyle: Theme.of(context).textTheme.bodyMedium,
            fields: const [
              TileField(
                start: Text('Maximum number of days'),
                end: Text('4 days'),
              ),
              TileField(
                start: Text('Effective by'),
                end: Text('Friday, Jan 20 2023'),
              ),
            ],
          )
        ].divide(const SizedBox(height: 16)).toList(),
      ),
    );
  }

  String getNotificationDate() {
    final DateTime now = DateTime.now();
    return DateFormat('MMM dd, yyyy hh:mm a').format(now);
  }
}
