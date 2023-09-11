import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class NavigationMenuDemo extends StatelessWidget {
  const NavigationMenuDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZdsList(
      padding: EdgeInsets.zero,
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          child: const ZdsProfile(
            avatar: ZdsNetworkAvatar(
              url: 'https://www.zebra.com/content/dam/zebra_dam/global/graphics/logos/zebra-logo-black-stacked.png',
              initials: 'JD',
            ),
            nameText: Text('Jason Davis'),
            jobTitleText: Text('Store Manager'),
          ).padding(kMenuHorizontalPadding.left),
        ),
        const Divider(),
        ZdsNavigationMenu(
          children: [
            ZdsMenuItem(
              label: const Text('Unit Name'),
              title: const Text('SR-CHI-Downers Grove IL.00101'),
              onTap: () {},
              trailing: const Icon(ZdsIcons.chevron_right),
            ),
            ZdsMenuItem(
              label: const Text('Department'),
              title: const Text('Store'),
              onTap: () {},
              trailing: const Icon(ZdsIcons.chevron_right),
            ),
            ZdsMenuItem(
              label: const Text('View type'),
              title: const Text('My View'),
              leading: const Icon(ZdsIcons.preview),
              onTap: () {},
              trailing: const Icon(ZdsIcons.chevron_right),
            ),
          ],
        ),
        ZdsNavigationMenu(
          withDividers: true,
          label: const Text('Other apps'),
          children: [
            ZdsMenuItem(
              title: const Text('Pinboard'),
              leading: const Icon(ZdsIcons.pin),
              onTap: () {},
              trailing: const Icon(ZdsIcons.launch),
            ),
            ZdsMenuItem(
              title: const Text('Q Chat'),
              leading: const Icon(ZdsIcons.chat_unread_active),
              onTap: () {},
              trailing: const Icon(ZdsIcons.launch),
            ),
            ZdsMenuItem(
              title: const Text('Q Walk'),
              leading: const Icon(ZdsIcons.walk),
              onTap: () {},
              trailing: const Icon(ZdsIcons.launch),
            ),
            ZdsMenuItem(
              title: const Text('Q Notes'),
              leading: const Icon(ZdsIcons.new_message),
              onTap: () {},
              trailing: const Icon(ZdsIcons.launch),
            ),
            ZdsMenuItem(
              title: const Text('Q Check'),
              leading: const Icon(ZdsIcons.report),
              onTap: () {},
              trailing: const Icon(ZdsIcons.launch),
            ),
            ZdsMenuItem(
              title: const Text('Q Forms'),
              leading: const Icon(ZdsIcons.form),
              onTap: () {},
              trailing: const Icon(ZdsIcons.launch),
            ),
            ZdsMenuItem(
              title: const Text('Q Docs'),
              leading: const Icon(ZdsIcons.project),
              onTap: () {},
              trailing: const Icon(ZdsIcons.launch),
            ),
            ZdsMenuItem(
              title: const Text('My Work'),
              leading: const Icon(ZdsIcons.task),
              onTap: () {},
              trailing: const Icon(ZdsIcons.launch),
            ),
          ],
        ),
        ZdsNavigationMenu(
          withDividers: true,
          children: [
            ZdsMenuItem(
              title: const Text('How do I'),
              leading: const Icon(ZdsIcons.how_do_I),
              onTap: () {},
              trailing: const Icon(ZdsIcons.chevron_right),
            ),
            ZdsMenuItem(
              title: const Text('About'),
              leading: const Icon(ZdsIcons.info),
              onTap: () {},
              trailing: const Icon(ZdsIcons.chevron_right),
            ),
            ZdsMenuItem(
              title: const Text('Private Device'),
              trailing: Switch(
                onChanged: (_) {},
                value: true,
              ),
            ),
          ],
        ),
        ZdsMenuItem(
          title: Text(
            'Sign Out',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          leading: Icon(ZdsIcons.sign_out, color: Theme.of(context).colorScheme.error),
          onTap: () {},
        ).paddingOnly(top: 10, bottom: 30),
      ],
    );
  }
}
