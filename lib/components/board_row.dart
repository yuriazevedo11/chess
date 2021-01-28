import 'package:chess/components/board_square.dart';
import 'package:flutter/material.dart';

class BoardRow extends StatelessWidget {
  final _squaresCount = List.filled(8, null);
  final int columnIndex;

  BoardRow({@required this.columnIndex});

  @override
  Widget build(BuildContext context) {
    List<BoardSquare> boardSquares = _squaresCount.asMap().entries.map(
      (item) {
        return BoardSquare(
          columnIndex: columnIndex,
          rowIndex: item.key,
        );
      },
    ).toList();

    return Expanded(
      child: Row(
        children: boardSquares,
      ),
    );
  }
}
