import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class InfiniteListDemo extends StatefulWidget {
  const InfiniteListDemo({Key? key}) : super(key: key);

  @override
  State<InfiniteListDemo> createState() => _InfiniteListDemoState();
}

class _InfiniteListDemoState extends State<InfiniteListDemo> {
  List<int> items = List.generate(20, (i) => i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ZdsInfiniteListView(
          compact: true,
          itemBuilder: (context, index) {
            return ZdsListTile(
              title: Text(index.toString()),
              onTap: () {},
            );
          },
          itemCount: items.length,
          hasMore: true,
          onLoadMore: () async {
            await Future.delayed(const Duration(milliseconds: 300));
            setState(() => items = [...items, ...List.generate(10, (i) => i + items.length)]);
          },
        ),
      ),
    );
  }
}
