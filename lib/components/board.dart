import 'package:chess/components/board_piece.dart';
import 'package:chess/components/board_row.dart';
import 'package:chess/components/square_marker.dart';
import 'package:chess/models/piece.dart';
import 'package:chess/models/position.dart';
import 'package:chess/utils/constants.dart';
import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  final String player;
  final List<List<Piece>> board;
  final bool Function(String, String) isMoveValid;

  Board({
    @required this.player,
    @required this.board,
    @required this.isMoveValid,
  });

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final _rowsCount = List.filled(8, null);
  Position _from;

  void _setMarkerPosition(Position from) {
    setState(() {
      _from = from;
    });
  }

  @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.width;
    double pieceSize = boardSize / 8;

    List<BoardRow> boardRows = _rowsCount.asMap().entries.map(
      (item) {
        return BoardRow(columnIndex: item.key);
      },
    ).toList();

    List<BoardPiece> pieces = new List();

    widget.board.asMap().forEach(
          (columnIndex, row) => row.asMap().forEach(
            (rowIndex, piece) {
              if (piece != null) {
                pieces.add(
                  BoardPiece(
                    piece: piece,
                    player: widget.player,
                    isMoveValid: widget.isMoveValid,
                    setMarkerPosition: _setMarkerPosition,
                    position: Position(
                      x: rowIndex * pieceSize,
                      y: columnIndex * pieceSize,
                    ),
                  ),
                );
              }
            },
          ),
        );

    if (widget.player == BLACK) {
      pieces = pieces.reversed.toList();
    }

    return Center(
      child: Container(
        height: boardSize,
        width: boardSize,
        child: Stack(
          children: [
            Column(children: boardRows),
            SquareMarker(from: _from, pieceSize: pieceSize),
            ...pieces,
          ],
        ),
      ),
    );
  }
}
