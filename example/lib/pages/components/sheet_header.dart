import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class SheetHeaderDemo extends StatelessWidget {
  const SheetHeaderDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZdsButton.filled(
            child: const Text('Show Sheet Header'),
            onTap: () => showBottomSheet(context),
          ),
          Container(
            color: Theme.of(context).colorScheme.onSurface,
            child: ZdsSheetHeader(
              headerText: 'Groups List',
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(ZdsIcons.close),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              ),
              trailing: ZdsButton.text(
                child: Text(
                  'New Group',
                  style:
                      Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                onTap: () {},
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.onSurface,
            child: ZdsSheetHeader(
              headerText: 'Filter List',
              leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(ZdsIcons.back)),
              trailing: ZdsButton.text(
                child: Icon(
                  ZdsIcons.filter,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                onTap: () {},
              ),
            ),
          ),
        ].divide(const SizedBox(height: 20)).toList(),
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    showZdsBottomSheet(
      context: context,
      headerBuilder: (context) => ZdsSheetHeader(
        headerText: 'Select Priority',
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(ZdsIcons.close),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ZdsListTile(
              leading: const Text('Urgent'),
              trailing: ZdsIndex(color: Zeta.of(context).colors.red, child: const Text('U')),
            ),
            ZdsListTile(
              leading: const Text('High'),
              trailing: ZdsIndex(color: Zeta.of(context).colors.orange, child: const Text('1')),
            ),
            ZdsListTile(
              leading: const Text('Medium'),
              trailing: ZdsIndex(color: Zeta.of(context).colors.teal, child: const Text('2')),
            ),
            ZdsListTile(
              leading: const Text('Low'),
              trailing: ZdsIndex(
                color: Zeta.of(context).colors.green,
                child: const Text('3'),
              ),
            ),
          ],
        ).paddingOnly(left: 16, right: 16);
      },
    );
  }
}
