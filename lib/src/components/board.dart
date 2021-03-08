import 'package:chess/src/components/board_piece.dart';
import 'package:chess/src/components/board_row.dart';
import 'package:chess/src/components/hint_move.dart';
import 'package:chess/src/components/square_marker.dart';
import 'package:chess/src/controllers/app_controller.dart';
import 'package:chess/src/models/position.dart';
import 'package:chess/src/utils/constants.dart';
import 'package:chess/src/utils/dimensions.dart';
import 'package:chess/src/utils/notations.dart';
import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final _rowsCount = List.filled(8, null);
  List<Position> _possibleMoves = [];
  Position _from;

  @override
  void didUpdateWidget(covariant Board oldWidget) {
    _from = null;
    _possibleMoves = [];
    super.didUpdateWidget(oldWidget);
  }

  void _setMarkerPosition(Position from, [double size]) {
    setState(() {
      if (from != null) {
        String square = positionToSquare(from, size);
        List<String> moves = AppController().getPossibleMovesFrom(square);

        List<Position> hints =
            moves.map((element) => squareToPosition(element, size)).toList();
        _possibleMoves = hints;
      }

      _from = from;
    });
  }

  void _moveFromHint(String to, double size) {
    String squareFrom = positionToSquare(_from, size);
    AppController().isMoveValid(squareFrom, to);

    setState(() {
      _from = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double boardSize = getBoardSize(context);
    double pieceSize = getSquareSize(context);

    Position checkPosition = AppController().inCheck != null
        ? squareToPosition(AppController().inCheck, pieceSize)
        : null;

    List<BoardRow> boardRows = _rowsCount.asMap().entries.map(
      (item) {
        return BoardRow(columnIndex: item.key);
      },
    ).toList();

    List<HintMove> hints = _possibleMoves
        .map(
          (position) => HintMove(
            position: position,
            moveFromHint: _moveFromHint,
          ),
        )
        .toList();

    List<BoardPiece> pieces = [];

    AppController().board.asMap().forEach(
          (columnIndex, row) => row.asMap().forEach(
            (rowIndex, piece) {
              if (piece != null) {
                pieces.add(
                  BoardPiece(
                    piece: piece,
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

    List<SquareMarker> lastMovePositions = [];

    if (AppController().lastMove != null) {
      lastMovePositions.add(
        SquareMarker(
          position: squareToPosition(
            AppController().lastMove.from,
            pieceSize,
          ),
        ),
      );
      lastMovePositions.add(
        SquareMarker(
          position: squareToPosition(
            AppController().lastMove.to,
            pieceSize,
          ),
        ),
      );
    }

    if (AppController().player == BLACK) {
      pieces = pieces.reversed.toList();
    }

    return Center(
      child: Container(
        height: boardSize,
        width: boardSize,
        child: Stack(
          children: [
            Column(children: boardRows),
            SquareMarker(position: checkPosition, color: Colors.red),
            SquareMarker(position: _from),
            ...lastMovePositions,
            ...pieces,
            ...hints,
          ],
        ),
      ),
    );
  }
}
