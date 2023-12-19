import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class BlockTableDemo extends StatelessWidget {
  const BlockTableDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final headers = [
      ZdsBlockTableHeader(text: 'Sun'),
      ZdsBlockTableHeader(text: 'Mon'),
      ZdsBlockTableHeader(text: 'Tue'),
      ZdsBlockTableHeader(text: 'Wed'),
      ZdsBlockTableHeader(text: 'Thur'),
      ZdsBlockTableHeader(text: 'Fri'),
      ZdsBlockTableHeader(text: 'Sat'),
    ];

    final data = [
      ZdsBlockTableRow(
        header: 'Grouping 1',
        titleCell: ZdsBlockTableCellData(text: 'Row 1'),
        data: [
          ZdsBlockTableCellData(text: '10am', isSelected: true),
          ZdsBlockTableCellData(
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Wrap(
                children: [
                  Icon(
                    ZdsIcons.add,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          ZdsBlockTableCellData(child: ZdsImages.sadZebra),
          ZdsBlockTableCellData(text: '1pm'),
          ZdsBlockTableCellData(text: '2pm'),
          ZdsBlockTableCellData(text: '3pm'),
          ZdsBlockTableCellData(text: '10am'),
        ],
      ),
      ZdsBlockTableRow(
        header: 'Grouping 1',
        titleCell: ZdsBlockTableCellData(text: 'Row 1'),
        data: [
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
        ],
      ),
      ZdsBlockTableRow(
        titleCell: ZdsBlockTableCellData(text: 'Row 1'),
        data: [
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
          ZdsBlockTableCellData(text: '10am'),
        ],
      ),
    ];

    return Scaffold(
      body: ZdsBlockTable(
        cellHeight: 90,
        headers: headers,
        rows: data,
      ),
    );
  }
}
