import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:html/dom.dart' as html;

/// Supported tags for [TableHtmlExtension] to use with flutter_html library.
const zdsTableTags = {
  'table',
  'tr',
  'tbody',
  'tfoot',
  'thead',
  'th',
  'td',
  'col',
  'p',
  'div',
  'blockquote',
  'ol',
  'ul',
  'li',
  'colgroup',
};

/// [TableHtmlExtension] adds support for the <table> element to the flutter_html library.
/// <tr>, <tbody>, <tfoot>, <thead>, <th>, <td>, <col>, and <colgroup> are also
/// supported.
///
/// Currently, nested tables are not supported.
class ZdsTableHtmlExtension extends HtmlExtension {
  /// Creates a new instance of the [ZdsTableHtmlExtension] widget.
  const ZdsTableHtmlExtension();

  @override
  Set<String> get supportedTags => zdsTableTags;

  @override
  bool matches(ExtensionContext context) {
    final String tag = context.elementName;
    return supportedTags.contains(tag) && (tag == 'table' || isTableParent(context.node));
  }

  //// Check if node has Table as ParentNode
  bool isTableParent(html.Node? node) {
    final String name = node?.parentNode?.elementName ?? '';
    if (name == 'table') {
      return true;
    } else if (node?.parentNode != null) {
      return isTableParent(node?.parentNode);
    } else {
      return false;
    }
  }

  @override
  StyledElement prepare(
    ExtensionContext context,
    List<StyledElement> children,
  ) {
    if (context.elementName == 'table') {
      final List<TableCellElement> cellDescendants = _getCellDescendants(children);
      return TableElement(
        name: context.elementName,
        elementId: context.id,
        elementClasses: context.classes.toList(),
        tableStructure: children,
        cellDescendants: cellDescendants,
        style: Style(display: Display.block),
        node: context.node,
      );
    }

    if (context.elementName == 'th' || context.elementName == 'td') {
      return TableCellElement(
        style: context.elementName == 'th'
            ? Style(
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                verticalAlign: VerticalAlign.middle,
              )
            : Style(
                verticalAlign: VerticalAlign.middle,
              ),
        children: children,
        node: context.node,
        name: context.elementName,
        elementClasses: context.classes.toList(),
        elementId: context.id,
      );
    }

    if (context.elementName == 'tbody' || context.elementName == 'thead' || context.elementName == 'tfoot') {
      return TableSectionLayoutElement(
        name: context.elementName,
        elementId: context.id,
        elementClasses: context.classes.toList(),
        children: children,
        style: Style(),
        node: context.node,
      );
    }

    if (context.elementName == 'tr') {
      return TableRowLayoutElement(
        name: context.elementName,
        elementId: context.id,
        elementClasses: context.classes.toList(),
        children: children,
        style: Style(),
        node: context.node,
      );
    }

    if (context.elementName == 'col' || context.elementName == 'colgroup') {
      return TableStyleElement(
        name: context.elementName,
        elementId: context.id,
        elementClasses: context.classes.toList(),
        children: children,
        style: Style(),
        node: context.node,
      );
    } else if (context.elementName == 'p' || context.elementName == 'li') {
      return TableStyleElement(
        name: context.elementName,
        elementId: context.id,
        elementClasses: context.classes.toList(),
        children: children,
        style: Style(after: '\n'),
        node: context.node,
      );
    } else if (context.elementName == 'blockquote') {
      return StyledElement(
        name: context.elementName,
        elementId: context.id,
        elementClasses: context.classes.toList(),
        children: children,
        style: Style(
          textAlign: TextAlign.end,
          verticalAlign: VerticalAlign.middle,
          margin: Margins.symmetric(horizontal: 40, vertical: 14),
          display: Display.block,
        ),
        node: context.node,
      );
    } else if (context.elementName == 'li') {
      return TableCellElement(
        name: context.elementName,
        elementId: context.id,
        elementClasses: context.classes.toList(),
        children: children,
        style: Style(
          display: Display.listItem,
        ),
        node: context.node,
      );
    } else if (context.elementName == 'ol') {
      return TableStyleElement(
        name: context.elementName,
        elementId: context.id,
        elementClasses: context.classes.toList(),
        children: children,
        style: Style(
          display: Display.block,
          listStyleType: ListStyleType.decimal,
          padding: HtmlPaddings.only(inlineStart: 40),
          margin: Margins(
            blockStart: Margin(1, Unit.em),
            blockEnd: Margin(1, Unit.em),
          ),
        ),
        node: context.node,
      );
    } else if (context.elementName == 'ul') {
      return TableStyleElement(
        name: context.elementName,
        elementId: context.id,
        elementClasses: context.classes.toList(),
        children: children,
        style: Style(
          display: Display.block,
          listStyleType: ListStyleType.disc,
          padding: HtmlPaddings.only(inlineStart: 40),
          margin: Margins(
            blockStart: Margin(1, Unit.em),
            blockEnd: Margin(1, Unit.em),
          ),
        ),
        node: context.node,
      );
    } else if (context.elementName == 'div') {
      return TableStyleElement(
        name: context.elementName,
        elementId: context.id,
        elementClasses: context.classes.toList(),
        children: children,
        style: Style(
          display: Display.block,
        ),
        node: context.node,
      );
    }

    return StyledElement(
      name: context.elementName,
      elementId: context.id,
      elementClasses: context.classes.toList(),
      node: context.node,
      children: children,
      style: Style(),
    );
  }

  @override
  InlineSpan build(ExtensionContext context) {
    if (context.elementName == 'table') {
      return WidgetSpan(
        child: CssBoxWidget(
          style: context.styledElement!.style,
          shrinkWrap: true,
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              if (context.styledElement != null && context.styledElement is TableElement) {
                return _layoutCells(
                  context.styledElement! as TableElement,
                  context.builtChildrenMap!,
                  context,
                  constraints,
                );
              }
              return const SizedBox();
            },
          ),
        ),
      );
    }

    return WidgetSpan(
      child: CssBoxWidget.withInlineSpanChildren(
        children: context.inlineSpanChildren!,
        style: Style(),
      ),
    );
  }
}

/// Recursively gets a flattened list of the table's
/// cell descendants
List<TableCellElement> _getCellDescendants(List<StyledElement> children) {
  final List<TableCellElement> descendants = <TableCellElement>[];

  for (final StyledElement child in children) {
    if (child is TableCellElement) {
      descendants.add(child);
    }

    descendants.addAll(_getCellDescendants(child.children));
  }

  return descendants;
}

Widget _layoutCells(
  TableElement table,
  Map<StyledElement, InlineSpan> parsedCells,
  ExtensionContext context,
  BoxConstraints constraints,
) {
  final List<TableRowLayoutElement> rows = <TableRowLayoutElement>[];
  List<TrackSize> columnSizes = <TrackSize>[];
  for (final StyledElement child in table.tableStructure) {
    if (child is TableStyleElement) {
      // Map <col> tags to predetermined column track sizes
      columnSizes = child.children
          .where((StyledElement c) => c.name == 'col')
          .map((StyledElement c) {
            final int span = int.tryParse(c.attributes['span'] ?? '1') ?? 1;
            final String? colWidth = c.attributes['width'];
            return List<TrackSize>.generate(span, (int index) {
              if (colWidth != null && colWidth.endsWith('%')) {
                if (!constraints.hasBoundedWidth) {
                  // In a horizontally unbounded container; always wrap content instead of applying flex
                  return const IntrinsicContentTrackSize();
                }
                final double? percentageSize = double.tryParse(colWidth.substring(0, colWidth.length - 1));
                return percentageSize != null && !percentageSize.isNaN
                    ? FlexibleTrackSize(percentageSize / 100)
                    : const IntrinsicContentTrackSize();
              } else if (colWidth != null) {
                final double? fixedPxSize = double.tryParse(colWidth);
                return fixedPxSize != null ? FixedTrackSize(fixedPxSize) : const IntrinsicContentTrackSize();
              } else {
                return const IntrinsicContentTrackSize();
              }
            });
          })
          .expand((List<TrackSize> element) => element)
          .toList(growable: false);
    } else if (child is TableSectionLayoutElement) {
      rows.addAll(child.children.whereType());
    } else if (child is TableRowLayoutElement) {
      rows.add(child);
    }
  }

  // All table rows have a height intrinsic to their (spanned) contents
  final List<IntrinsicContentTrackSize> rowSizes = List<IntrinsicContentTrackSize>.generate(
    rows.length,
    (_) => const IntrinsicContentTrackSize(),
  );

  // Calculate column bounds
  int columnMax = 0;
  List<int> rowSpanOffsets = <int>[];
  for (final TableRowLayoutElement row in rows) {
    final int cols = row.children
            .whereType<TableCellElement>()
            .fold(0, (int value, TableCellElement child) => value + child.colspan) +
        rowSpanOffsets.fold<int>(0, (int offset, int child) => child);
    columnMax = max(cols, columnMax);
    rowSpanOffsets = <int>[
      ...rowSpanOffsets.map((int value) => value - 1).where((int value) => value > 0),
      ...row.children.whereType<TableCellElement>().map((TableCellElement cell) => cell.rowspan - 1),
    ];
  }

  // Place the cells in the rows/columns
  final List<GridPlacement> cells = <GridPlacement>[];
  final List<int> columnRowOffset = List<int>.generate(columnMax, (_) => 0);
  final List<int> columnColspanOffset = List<int>.generate(columnMax, (_) => 0);
  int rowi = 0;
  for (final TableRowLayoutElement row in rows) {
    int columni = 0;
    for (final StyledElement child in row.children) {
      if (columni > columnMax - 1) {
        break;
      }
      if (child is TableCellElement) {
        while (columnRowOffset[columni] > 0) {
          columnRowOffset[columni] = columnRowOffset[columni] - 1;
          columni += columnColspanOffset[columni].clamp(1, columnMax - columni - 1);
        }
        cells.add(
          GridPlacement(
            columnStart: columni,
            columnSpan: min(child.colspan, columnMax - columni),
            rowStart: rowi,
            rowSpan: min(child.rowspan, rows.length - rowi),
            child: CssBoxWidget(
              style: child.style.merge(row.style),
              child: Builder(
                builder: (BuildContext context) {
                  final TextDirection alignment = child.style.direction ?? Directionality.of(context);
                  return SizedBox.expand(
                    child: Container(
                      alignment: _getCellAlignment(child, alignment),
                      child: CssBoxWidget.withInlineSpanChildren(
                        children: <InlineSpan>[
                          parsedCells[child] ?? const TextSpan(text: 'error'),
                        ],
                        style: Style(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
        columnRowOffset[columni] = child.rowspan - 1;
        columnColspanOffset[columni] = child.colspan;
        columni += child.colspan;
      }
    }
    while (columni < columnRowOffset.length) {
      columnRowOffset[columni] = columnRowOffset[columni] - 1;
      columni++;
    }
    rowi++;
  }

  // Create column tracks (insofar there were no colgroups that already defined them)
  List<TrackSize> finalColumnSizes = columnSizes.take(columnMax).toList();
  finalColumnSizes += List<TrackSize>.generate(
    max(0, columnMax - finalColumnSizes.length),
    (_) => const IntrinsicContentTrackSize(),
  );

  if (finalColumnSizes.isEmpty || rowSizes.isEmpty) {
    // No actual cells to show
    return const SizedBox();
  }

  return LayoutGrid(
    gridFit: GridFit.loose,
    columnSizes: finalColumnSizes,
    rowSizes: rowSizes,
    children: cells,
  );
}

Alignment _getCellAlignment(TableCellElement cell, TextDirection alignment) {
  Alignment verticalAlignment;

  switch (cell.style.verticalAlign) {
    case VerticalAlign.baseline:
    case VerticalAlign.sub:
    case VerticalAlign.sup:
    case VerticalAlign.top:
      verticalAlignment = Alignment.topCenter;
    case VerticalAlign.middle:
      verticalAlignment = Alignment.center;
    case VerticalAlign.bottom:
      verticalAlignment = Alignment.bottomCenter;
  }

  switch (cell.style.textAlign) {
    case TextAlign.left:
      return verticalAlignment + Alignment.centerLeft;
    case TextAlign.right:
      return verticalAlignment + Alignment.centerRight;
    case TextAlign.center:
      return verticalAlignment + Alignment.center;
    case null:
    case TextAlign.start:
    case TextAlign.justify:
      switch (alignment) {
        case TextDirection.rtl:
          return verticalAlignment + Alignment.centerRight;
        case TextDirection.ltr:
          return verticalAlignment + Alignment.centerLeft;
      }
    case TextAlign.end:
      switch (alignment) {
        case TextDirection.rtl:
          return verticalAlignment + Alignment.centerLeft;
        case TextDirection.ltr:
          return verticalAlignment + Alignment.centerRight;
      }
  }
}

extension _ElementName on html.Node {
  String get elementName {
    if (this is html.Element) {
      return (this as html.Element).localName ?? '';
    }
    return '';
  }
}
