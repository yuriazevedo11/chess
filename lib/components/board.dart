import 'package:chess/components/board_piece.dart';
import 'package:chess/components/board_row.dart';
import 'package:chess/models/piece.dart';
import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  final _rowsCount = List.filled(8, null);
  final List<List<Piece>> board;

  Board({@required this.board});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    List<BoardRow> boardRows = _rowsCount.asMap().entries.map(
      (item) {
        return BoardRow(columnIndex: item.key);
      },
    ).toList();

    List<BoardPiece> pieces = new List();

    board.forEach(
      (row) => row.forEach(
        (piece) {
          if (piece != null) {
            pieces.add(
              BoardPiece(piece: piece),
            );
          }
        },
      ),
    );

    return Center(
      child: Container(
        height: size,
        width: size,
        child: Stack(
          children: [
            Column(children: boardRows),
            ...pieces,
          ],
        ),
      ),
    );
  }
}
