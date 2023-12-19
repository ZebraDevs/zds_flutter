import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class ExpansionTileDemo extends StatefulWidget {
  const ExpansionTileDemo({Key? key}) : super(key: key);

  @override
  State<ExpansionTileDemo> createState() => _ExpansionTileDemoState();
}

class _ExpansionTileDemoState extends State<ExpansionTileDemo> {
  final List<Location> _items = [
    Location('Store 101', 'North Main Street'),
    Location('Store 102', 'North Main Street'),
  ];

  List<Location> _selectedItems = [];

  void _itemChange(Location item, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            ZdsCard(
              padding: EdgeInsets.zero,
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
                  ZdsExpansionTile(
                    title: const Text('Customer Service'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer Service Report', style: Theme.of(context).textTheme.bodyMedium).space(8),
                        Text('New Hire Training Confirmation', style: Theme.of(context).textTheme.bodyMedium).space(),
                      ],
                    ),
                  ),
                  ZdsExpansionTile(
                    title: const Text('Management Audit Checklist'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Copy-1712 products and services...', style: Theme.of(context).textTheme.bodyMedium)
                            .space(),
                      ],
                    ),
                  ),
                  ZdsExpansionTile(
                    title: const Text('Store survey Checklist to evaluate the other'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Survey displays to evaluate if they are...',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ).space(8),
                        Text(
                          'Window displays to evaluate if they are...',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ).space(),
                      ],
                    ),
                  ),
                  ZdsExpansionTile(
                    title: const Text('Collect feedback from customers who was'),
                    initiallyExpanded: true,
                    titleColor: const Color(0xff007ABA).withOpacity(0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Products and services offered, pricing', style: Theme.of(context).textTheme.bodyMedium)
                            .space(),
                      ],
                    ),
                  ),
                ],
              ),
            ).space(20),
            ZdsCard(
              padding: EdgeInsets.zero,
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
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ZdsButton.outlined(
                          child: const Text('Clear'),
                          onTap: () {},
                        ),
                        const SizedBox(width: 8),
                        ZdsButton(
                          child: const Text('Apply'),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).space(20),
            ZdsExpansionTile(
              title: const Text('Tile outside of a card'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sub-tile №1', style: Theme.of(context).textTheme.bodyMedium).space(6),
                  Text(
                    'Another tile that will be hidden after pressing on the expansion tile',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).space(),
                ],
              ),
            ).space(20),
            ZdsExpansionTile(
              title: const Text('Placeholder Name One'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14).copyWith(bottom: 6),
              bottom: const Padding(
                padding: EdgeInsets.only(left: 22, right: 22, bottom: 8),
                child: Row(
                  children: [
                    ZdsTag(
                      rectangular: true,
                      child: Text('Read'),
                    ),
                    ZdsTag(
                      rectangular: true,
                      child: Text('Write'),
                    ),
                    ZdsTag(
                      rectangular: true,
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ),
              child: ZdsList(
                shrinkWrap: true,
                children: [
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    dense: true,
                    title: const Text('Read'),
                    value: true,
                    onChanged: (val) {},
                  ),
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    dense: true,
                    title: const Text('Write'),
                    value: true,
                    onChanged: (val) {},
                  ),
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    dense: true,
                    title: const Text('Delete'),
                    value: true,
                    onChanged: (val) {},
                  ),
                ],
              ),
            ).space(60),
            ZdsCard(
              padding: EdgeInsets.zero,
              child: ZdsExpansionTile.selectable(
                titlePadding: const EdgeInsets.all(14),
                contentPadding: const EdgeInsets.all(2),
                title: const Text('Region 3'),
                selected: _selectedItems.length > 1,
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _selectedItems.addAll(_items);
                    } else {
                      _selectedItems = [];
                    }
                  });
                },
                child: ZdsList.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return ZdsListTile(
                      shrinkWrap: true,
                      backgroundColor: Colors.transparent,
                      title: Text(_items[index].title!).paddingOnly(left: 52),
                      trailing: _selectedItems.contains(_items[index])
                          ? Icon(ZdsIcons.check, color: Theme.of(context).colorScheme.secondary)
                          : null,
                      onTap: () {
                        _itemChange(_items[index], _selectedItems.contains(_items[index]));
                      },
                    );
                  },
                ),
              ),
            ).space(20),
          ],
        ),
      ),
    );
  }
}

class Location {
  final String? title;
  final String? subtitle;

  Location(this.title, this.subtitle);
}
