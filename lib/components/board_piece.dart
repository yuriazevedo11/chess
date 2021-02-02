import 'package:chess/models/piece.dart';
import 'package:chess/models/position.dart';
import 'package:chess/utils/notations.dart';
import 'package:flutter/material.dart';

class BoardPiece extends StatefulWidget {
  final Piece piece;
  final String player;
  final bool Function(String, String) isMoveValid;
  final Position position;
  final void Function(Position) setMarkerPosition;

  BoardPiece({
    @required this.piece,
    @required this.player,
    @required this.isMoveValid,
    @required this.position,
    @required this.setMarkerPosition,
  });

  @override
  _BoardPieceState createState() => _BoardPieceState();
}

class _BoardPieceState extends State<BoardPiece> {
  Position _position;
  String _from;

  @override
  void initState() {
    _position = Position(x: widget.position.x, y: widget.position.y);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BoardPiece oldWidget) {
    _position = Position(x: widget.position.x, y: widget.position.y);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 8;
    bool isPiecePlayable = widget.piece.color == widget.player;

    return Positioned(
      top: _position.y,
      left: _position.x,
      child: GestureDetector(
        onPanStart: isPiecePlayable
            ? (DragStartDetails details) {
                widget.setMarkerPosition(_position);
                setState(() {
                  _from = positionToSquare(_position, size);
                });
              }
            : null,
        onPanUpdate: isPiecePlayable
            ? (DragUpdateDetails details) {
                setState(() {
                  _position = Position(
                    x: _position.x + details.delta.dx,
                    y: _position.y + details.delta.dy,
                  );
                });
              }
            : null,
        onPanEnd: isPiecePlayable
            ? (DragEndDetails details) {
                String to = positionToSquare(_position, size);
                bool isMoveValid = widget.isMoveValid(_from, to);
                widget.setMarkerPosition(null);

                setState(() {
                  if (!isMoveValid) {
                    _position = widget.position;
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
