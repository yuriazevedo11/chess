import 'package:chess/components/board_row.dart';
import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  final _rowsCount = List.filled(8, null);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    List<BoardRow> boardRows = _rowsCount.asMap().entries.map(
      (item) {
        return BoardRow(columnIndex: item.key);
      },
    ).toList();

    return Center(
      child: Container(
        height: size,
        width: size,
        child: Column(children: boardRows),
      ),
    );
  }
}
