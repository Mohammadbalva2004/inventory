import 'package:flutter/material.dart';

class CommonDataTable extends StatelessWidget {
  final List<String> columnTitles;
  final List<List<Widget>> rowCells;
  final bool hasActions;
  final double columnSpacing;
  final double dataRowHeight;

  const CommonDataTable({
    super.key,
    required this.columnTitles,
    required this.rowCells,
    this.hasActions = false,
    this.columnSpacing = 40,
    this.dataRowHeight = 72,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: columnSpacing,
          headingRowHeight: 56,
          dataRowHeight: dataRowHeight,
          columns: [
            ...columnTitles.map((title) => DataColumn(label: Text(title))),
            if (hasActions) const DataColumn(label: Text('Actions')),
          ],
          rows:
              rowCells.map((cellWidgets) {
                final cells = [
                  ...cellWidgets.map((widget) => DataCell(widget)),
                  if (hasActions &&
                      cellWidgets.length < columnTitles.length + 1)
                    const DataCell(SizedBox.shrink()), // filler
                ];
                return DataRow(cells: cells);
              }).toList(),
        ),
      ),
    );
  }
}
