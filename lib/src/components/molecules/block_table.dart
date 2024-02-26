import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../../../zds_flutter.dart';

/// Defines a header for a [ZdsBlockTable]
class ZdsBlockTableHeader {
  /// Creates a new [ZdsBlockTableHeader]
  ZdsBlockTableHeader({
    required this.text,
    this.textColor,
  });

  /// The text displayed on the header
  final String text;

  /// The color of the text
  final Color? textColor;
}

/// Defines a row in a [ZdsBlockTable]
class ZdsBlockTableRow {
  /// Creates a new [ZdsBlockTableRow]
  ZdsBlockTableRow({
    required this.data,
    required this.titleCell,
    this.header,
  });

  /// The header text displayed above the row
  final String? header;

  /// The cell that is used as the title cell for the row
  final ZdsBlockTableCellData titleCell;

  /// The data displayed in the table
  final List<ZdsBlockTableCellData> data;
}

/// Defines a cell in a [ZdsBlockTable]
class ZdsBlockTableCellData {
  /// Creates a new [ZdsBlockTableCellData]
  ZdsBlockTableCellData({
    this.text,
    this.child,
    this.textColor,
    this.backgroundColor,
    this.textStyle,
    this.isSelected,
    this.onTap,
  });

  /// The child of the cell. Cannot be set if [text] is defined
  final Widget? child;

  /// The text displayed in the cell. Cannot be set if [child] is defined
  final String? text;

  /// The color of the text
  final Color? textColor;

  /// The background color of the cell
  final Color? backgroundColor;

  /// The style of the text
  final TextStyle? textStyle;

  /// The function called when the cell is tapped
  final void Function()? onTap;

  /// If set to true, gives the cell a highlight background and border
  bool? isSelected;
}

/// A scrollable table with floating headers
class ZdsBlockTable extends StatefulWidget {
  /// Creates a new [ZdsBlockTable]
  const ZdsBlockTable({
    required this.headers,
    required this.rows,
    this.columnWidth = 80,
    this.cellHeight = 34,
    this.cellPadding = 18,
    this.rowHeaderHeight = 24,
    super.key,
  });

  /// The table headers
  final List<ZdsBlockTableHeader> headers;

  /// The table rows
  final List<ZdsBlockTableRow> rows;

  /// The width of each column
  final double columnWidth;

  /// The height of each cell
  final double cellHeight;

  /// The vertical padding within each cell
  final double cellPadding;

  /// The multiple for height of row header
  final double rowHeaderHeight;

  @override
  State<ZdsBlockTable> createState() => _BlockTable();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<ZdsBlockTableHeader>('headers', headers))
      ..add(IterableProperty<ZdsBlockTableRow>('rows', rows))
      ..add(DoubleProperty('columnWidth', columnWidth))
      ..add(DoubleProperty('cellHeight', cellHeight))
      ..add(DoubleProperty('cellPadding', cellPadding))
      ..add(DoubleProperty('rowHeaderHeight', rowHeaderHeight));
  }
}

class _BlockTable extends State<ZdsBlockTable> with WidgetsBindingObserver {
  final LinkedScrollControllerGroup _controllers = LinkedScrollControllerGroup();
  late final double headerHeight;

  late ScrollController _tableHeader;
  late ScrollController _tableBody;

  Widget zeroCellWidget = const SizedBox();
  List<Widget> headerCellsWidgets = <Widget>[];
  List<Widget> firstColumnCellsWidgets = <Widget>[];
  List<Widget> bodyCellsWidgets = <Widget>[];

  @override
  void initState() {
    super.initState();
    _tableHeader = _controllers.addAndGet();
    _tableBody = _controllers.addAndGet();

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      headerHeight = widget.rowHeaderHeight;
      buildTable();
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      buildTable();
    });
  }

  void buildTable() {
    if (!mounted) return;
    setState(() {
      zeroCellWidget = _getZeroCellWidget();
      headerCellsWidgets = _buildHeaderCells(widget.headers);
      firstColumnCellsWidgets = _buildFirstColumnCells(widget.rows);
      bodyCellsWidgets = _buildBodyRows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Zeta.of(context).colors.borderSubtle,
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                zeroCellWidget,
                Flexible(
                  flex: 3,
                  child: SingleChildScrollView(
                    controller: _tableHeader,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: headerCellsWidgets,
                    ),
                  ),
                ),
              ],
            ).paddingOnly(bottom: 1),
            Flexible(
              child: _workingFixedColScrollable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _workingFixedColScrollable() {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: firstColumnCellsWidgets,
          ),
          Flexible(
            child: SingleChildScrollView(
              controller: _tableBody,
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: bodyCellsWidgets,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHeaderCells(List<ZdsBlockTableHeader> items) {
    return List<Widget>.generate(
      items.length,
      (int index) {
        final themeData = Theme.of(context);
        return Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: _getDayColumnWidth(),
              height: 28,
              color: themeData.colorScheme.surface,
              child: Text(
                items[index].text,
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: items[index].textColor,
                ),
              ),
            ),
            const SizedBox(
              width: 1,
            ),
          ],
        );
      },
      growable: false,
    );
  }

  List<Widget> _buildFirstColumnCells(List<ZdsBlockTableRow> rows) {
    return List<Widget>.generate(
      rows.length,
      (int index) {
        final ZdsBlockTableRow row = rows[index];
        final ZdsBlockTableCellData cellItem = row.titleCell;
        final themeData = Theme.of(context);

        return Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (row.header != null)
                  Container(
                    height: headerHeight,
                    width: _getAssocColumnWidth(),
                    decoration: BoxDecoration(
                      color: Zeta.of(context).colors.borderDisabled,
                      border: Border(
                        bottom: BorderSide(
                          color: Zeta.of(context).colors.borderSubtle,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        row.header!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: themeData.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                Container(
                  alignment: Alignment.center,
                  width: _getAssocColumnWidth(),
                  height: widget.cellHeight + widget.cellPadding,
                  color: cellItem.backgroundColor ?? themeData.colorScheme.surface,
                  margin: const EdgeInsets.only(bottom: 1),
                  child: cellItem.child ??
                      Text(
                        cellItem.text ?? '',
                        style: cellItem.textStyle ??
                            themeData.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: cellItem.textColor ?? themeData.colorScheme.onSurface,
                            ),
                      ).paddingOnly(left: 8),
                ),
              ],
            ),
            const SizedBox(
              width: 1,
            ),
          ],
        );
      },
      growable: false,
    );
  }

  List<Widget> _buildRowElements(int index) {
    final List<Widget> cells = <Widget>[];
    final List<ZdsBlockTableRow> rows = widget.rows;
    final double cellHeight = widget.cellHeight + widget.cellPadding;

    for (int j = 0; j < rows[index].data.length; j++) {
      final List<Widget> columnWidgets = <Widget>[];

      if (rows[index].header != null) {
        columnWidgets.add(
          Container(
            height: headerHeight,
            decoration: BoxDecoration(
              color: Zeta.of(context).colors.borderDisabled,
              border: Border(
                bottom: BorderSide(color: Zeta.of(context).colors.borderSubtle),
              ),
            ),
          ),
        );
      }
      final ZdsBlockTableCellData tableCell = rows[index].data[j];
      final bool isSelected = tableCell.isSelected != null && tableCell.isSelected!;

      final themeData = Theme.of(context);
      columnWidgets.add(
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: isSelected ? Border.all(color: themeData.colorScheme.secondary, width: 2) : null,
              color: isSelected
                  ? themeData.colorScheme.secondary.withLight(0.1, background: themeData.colorScheme.background)
                  : tableCell.backgroundColor ?? themeData.colorScheme.surface,
            ),
            child: Align(
              child: tableCell.child ??
                  Text(
                    tableCell.text!,
                    textAlign: TextAlign.center,
                    style: tableCell.textStyle ??
                        themeData.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: tableCell.textColor ?? themeData.colorScheme.onSurface,
                        ),
                  ),
            ),
          ),
        ),
      );

      final Widget cellBody = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: columnWidgets,
      );

      final Widget cell = tableCell.onTap == null
          ? cellBody
          : GestureDetector(
              onTap: tableCell.onTap,
              child: cellBody,
            );

      cells.add(cell);
    }

    return List<Widget>.generate(
      cells.length,
      (int indx) => Row(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: _getDayColumnWidth(),
            height: cellHeight + (rows[index].header != null ? headerHeight : 0),
            child: cells[indx],
          ),
          const SizedBox(
            width: 1,
          ),
        ],
      ),
      growable: false,
    );
  }

  List<Widget> _buildBodyRows() {
    return List<Widget>.generate(
      widget.rows.length,
      (int index) {
        return Row(
          children: _buildRowElements(index),
        ).paddingOnly(bottom: 1);
      },
      growable: false,
    );
  }

  Widget _getZeroCellWidget() {
    return Container(
      alignment: Alignment.center,
      width: _getAssocColumnWidth(),
      height: 28,
      color: Theme.of(context).colorScheme.surface,
    ).paddingOnly(right: 1);
  }

  double _getAssocColumnWidth() {
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    if (!isLandscape) {
      return _firstColMinWidth();
    }
    final double screenWidth = _screenWidthSafe();
    return screenWidth - _getDayColumnWidth() * 7;
  }

  double _firstColMinWidth() {
    return widget.columnWidth + 40;
  }

  double _screenWidthSafe() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double leftSafe = MediaQuery.of(context).padding.left;
    return screenWidth - leftSafe;
  }

  double _getDayColumnWidth() {
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    if (!isLandscape && (!context.isTablet())) {
      return widget.columnWidth;
    }
    double screenWidth = _screenWidthSafe().floorToDouble();
    screenWidth -= _firstColMinWidth(); // remove first column
    final double suggestedWidth = (screenWidth / 7).floorToDouble();
    return suggestedWidth > widget.columnWidth ? suggestedWidth : widget.columnWidth;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('headerHeight', headerHeight));
  }
}
