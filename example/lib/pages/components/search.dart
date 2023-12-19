import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class SearchDemo extends StatefulWidget {
  const SearchDemo({Key? key}) : super(key: key);

  @override
  _SearchDemoState createState() => _SearchDemoState();
}

class _SearchDemoState extends State<SearchDemo> {
  final TextEditingController _clearButtonFieldController = TextEditingController();

  bool _showSearchAppBarOverlay = false;
  bool _showSuffixClearButton = false;

  void _cancel() {
    setState(() {
      _showSearchAppBarOverlay = false;
    });

    Navigator.of(context).pop();
  }

  void _toggleSearchOverlay() {
    setState(() {
      _showSearchAppBarOverlay = !_showSearchAppBarOverlay;
    });
  }

  void _showSearchOverlay() {
    setState(() {
      _showSearchAppBarOverlay = true;
    });
  }

  @override
  void initState() {
    super.initState();

    _clearButtonFieldController.addListener(() {
      setState(() {
        _showSuffixClearButton = _clearButtonFieldController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final clearButton = _showSuffixClearButton
        ? IconButton(
            icon: Icon(ZdsIcons.close_circle, color: Zeta.of(context).colors.iconSubtle),
            onPressed: _clearButtonFieldController.clear,
          )
        : null;

    return Scaffold(
      appBar: ZdsSearchAppBar(
        leading: IconButton(
          icon: Icon(
            ZdsIcons.search_advance,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: _toggleSearchOverlay,
        ),
        trailing: ZdsButton.text(
          onTap: _cancel,
          child: const Text('Cancel'),
        ),
        hintText: 'Search in the App Bar',
        showOverlay: _showSearchAppBarOverlay,
        overlayBuilder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('no results found...').padding(5),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Icon(
                    ZdsIcons.search_advance,
                    color: Theme.of(context).primaryColor,
                  ).padding(5),
                  const Text('Try smart search').textStyle(
                      Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor))
                ],
              ),
            )
          ],
        ).padding(10),
        onSubmit: (_) => _showSearchOverlay(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.all(8),
              child: ZdsSearchField(
                controller: _clearButtonFieldController,
                hintText: 'Search with clear button',
                suffixIcon: clearButton,
                variant: ZdsSearchFieldVariant.outlined,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.all(8),
              child: const ZdsSearchField(
                hintText: 'Search',
                initValue: 'search data',
                variant: ZdsSearchFieldVariant.outlined,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8),
              child: ZdsSearchField(hintText: 'Search'),
            ),
          ],
        ),
      ),
    );
  }
}
