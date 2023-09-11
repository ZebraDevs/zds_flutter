import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class EmptyListView extends StatelessWidget {
  const EmptyListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ZdsButton(
            child: const Text('show empty list view'),
            onTap: () => showBottomSheet1(context),
          ),
          ZdsButton(
            child: const Text('show empty list view 2'),
            onTap: () => showBottomSheet2(context),
          ),
        ],
      ),
    );
  }

  void showBottomSheet1(BuildContext context) {
    showZdsBottomSheet(
      context: context,
      headerBuilder: (context) => PreferredSize(
        preferredSize: const Size(double.infinity, 82),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 10),
          color: Theme.of(context).colorScheme.surface,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.primary),
            child: Row(
              children: [
                const Expanded(
                  flex: 6,
                  child: ZdsSearchField(
                    variant: ZdsSearchFieldVariant.outlined,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(ZdsIcons.filter),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(ZdsIcons.info),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      builder: (context) => ZdsList(
        showEmpty: true,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
      ),
    );
  }

  void showBottomSheet2(BuildContext context) {
    showZdsBottomSheet(
      context: context,
      headerBuilder: (context) => PreferredSize(
        preferredSize: const Size(double.infinity, 82),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 10),
          color: Theme.of(context).colorScheme.surface,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.primary),
            child: Row(
              children: [
                const Expanded(
                  flex: 6,
                  child: ZdsSearchField(
                    variant: ZdsSearchFieldVariant.outlined,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(ZdsIcons.filter),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(ZdsIcons.info),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      builder: (context) => ZdsList.builder(
        physics: const ClampingScrollPhysics(),
        showEmpty: true,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return const ZdsListTile(
            title: Text('List tile'),
          );
        },
      ),
    );
  }
}
