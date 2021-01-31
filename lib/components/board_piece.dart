import 'package:chess/models/piece.dart';
import 'package:chess/models/position.dart';
import 'package:chess/utils/notations.dart';
import 'package:flutter/material.dart';

class BoardPiece extends StatefulWidget {
  final Piece piece;
  final Position position;

  BoardPiece({
    @required this.piece,
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
    super.initState();
    position = Position(x: widget.position.x, y: widget.position.y);
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 8;

    return Positioned(
      top: position.y,
      left: position.x,
      child: GestureDetector(
        onPanStart: (DragStartDetails details) {
          setState(() {
            from = positionToSquare(position, size);
          });
        },
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            position = Position(
              x: position.x + details.delta.dx,
              y: position.y + details.delta.dy,
            );
          });
        },
        onPanEnd: (DragEndDetails details) {
          String square = positionToSquare(position, size);
          Position boardPosition = squareToPosision(square, size);

          // TODO validade move
          print({'from': from, 'to': square});

          // If move is valid, move piece and update board
          setState(() {
            position = boardPosition;
            // TODO update board
          });

          // If move is not valid, return piece to initial position
          // setState(() {
          //   position = Position(x: widget.position.x, y: widget.position.y);
          // });
        },
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
