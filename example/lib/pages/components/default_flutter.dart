import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class DefaultFlutter extends StatelessWidget {
  const DefaultFlutter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: ZdsList(
            children: [
              Card(
                child: Wrap(
                  spacing: 8,
                  children: [
                    Radio(
                      value: 'A',
                      groupValue: 'A',
                      onChanged: (_) {},
                    ),
                    Radio(
                      value: 'B',
                      groupValue: 'A',
                      onChanged: (_) {},
                    ),
                    Checkbox(
                      value: true,
                      onChanged: (_) {},
                    ),
                    Checkbox(
                      value: false,
                      onChanged: (_) {},
                    ),
                    Switch(
                      value: true,
                      onChanged: (_) {},
                    ),
                    Switch(
                      value: false,
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Slider(
                      value: 50,
                      onChanged: (value) {},
                      divisions: 10,
                      min: 0,
                      max: 100,
                    ),
                    Slider(
                      value: 50,
                      secondaryTrackValue: 80,
                      onChanged: (value) {},
                      min: 0,
                      max: 100,
                    ),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Enter Name',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            showDateRangePicker(
                              context: context,
                              firstDate: DateTime.now().add(Duration(days: -365)),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                          },
                          child: Text("Select Date")),
                      OutlinedButton(onPressed: () {}, child: Text("OutlinedButton")),
                      TextButton(onPressed: () {}, child: Text("TextButton")),
                    ],
                  ),
                ),
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.access_alarm)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.access_alarm)),
                  ],
                ),
              ),
              SearchBar(hintText: 'Search with name'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        avatar: Icon(Icons.person),
                        label: Text('Default Chip'),
                      ),
                      Chip(
                        label: Text('Default Chip'),
                        onDeleted: () {},
                      ),
                      InputChip(
                        selected: true,
                        label: Text('Default Chip'),
                        onSelected: (_) {},
                      ),
                      InputChip(
                        isEnabled: false,
                        label: Text('Default Chip'),
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
              BottomAppBar(
                child: Row(
                  children: [
                    TextButton(onPressed: () {}, child: Text("Cancel")),
                    const Spacer(),
                    OutlinedButton(onPressed: () {}, child: Text("Reset")),
                    SizedBox(width: ZetaSpacing.xs),
                    ElevatedButton(onPressed: () {}, child: Text("Next")),
                  ],
                ),
              ),
              BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(label: 'Feeds', icon: Icon(Icons.feed_outlined)),
                  BottomNavigationBarItem(label: 'Calendar', icon: Icon(Icons.calendar_month)),
                ],
              ),
              TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home), text: "Home"),
                  Tab(icon: Icon(Icons.search), text: "Search"),
                  Tab(icon: Icon(Icons.settings), text: "Settings"),
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Card'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.access_alarm),
                trailing: Icon(Icons.chevron_right),
                title: Text('ListTile Title'),
                subtitle: Text('ListTile Subtitle'),
                onTap: () {},
              ),
              ListTile(
                selected: true,
                leading: Icon(Icons.access_alarm),
                trailing: Icon(Icons.chevron_right),
                title: Text('ListTile Title'),
                subtitle: Text('ListTile Subtitle'),
                onTap: () {},
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.access_alarm),
                  trailing: Icon(Icons.chevron_right),
                  title: Text('ListTile Title'),
                  subtitle: Text('ListTile Subtitle'),
                ),
              ),
            ].divide(const SizedBox(height: 20)).toList(),
          ),
        ),
      ),
    );
  }
}
