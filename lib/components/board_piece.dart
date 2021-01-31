import 'package:chess/models/piece.dart';
import 'package:chess/models/position.dart';
import 'package:chess/utils/notations.dart';
import 'package:flutter/material.dart';

class BoardPiece extends StatefulWidget {
  final Piece piece;
  final String player;
  final bool Function(String, String) isMoveValid;
  final Position position;

  BoardPiece({
    @required this.piece,
    @required this.player,
    @required this.isMoveValid,
    @required this.position,
  });

  @override
  _BoardPieceState createState() => _BoardPieceState();
}

class _BoardPieceState extends State<BoardPiece> {
  Position position;
  String from;

  @override
  void initState() {
    position = Position(x: widget.position.x, y: widget.position.y);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BoardPiece oldWidget) {
    super.didUpdateWidget(oldWidget);
    position = Position(x: widget.position.x, y: widget.position.y);
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 8;
    bool isPiecePlayable = widget.piece.color == widget.player;

    return Positioned(
      top: position.y,
      left: position.x,
      child: GestureDetector(
        onPanStart: isPiecePlayable
            ? (DragStartDetails details) {
                setState(() {
                  from = positionToSquare(position, size);
                });
              }
            : null,
        onPanUpdate: isPiecePlayable
            ? (DragUpdateDetails details) {
                setState(() {
                  position = Position(
                    x: position.x + details.delta.dx,
                    y: position.y + details.delta.dy,
                  );
                });
              }
            : null,
        onPanEnd: isPiecePlayable
            ? (DragEndDetails details) {
                String to = positionToSquare(position, size);
                Position boardPosition = squareToPosision(to, size);

                bool isMoveValid = widget.isMoveValid(from, to);

                setState(() {
                  if (isMoveValid) {
                    position = boardPosition;
                  } else {
                    position = Position(
                      x: widget.position.x,
                      y: widget.position.y,
                    );
                  }
                });
              }
            : null,
        child: Image(
          height: size,
          width: size,
          image: AssetImage(
            'assets/images/${widget.piece.color}${widget.piece.type}.png',
          ),
        ),
      ),
    );
  }
}
