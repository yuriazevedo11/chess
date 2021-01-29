import 'package:chess/models/piece.dart';
import 'package:chess/models/position.dart';
import 'package:flutter/material.dart';

class BoardPiece extends StatelessWidget {
  final Piece piece;
  final Position position;

  BoardPiece({
    @required this.piece,
    @required this.position,
  });

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 8;

    return Positioned(
      top: position.y,
      left: position.x,
      child: Image(
        height: size,
        width: size,
        image: AssetImage(
          'assets/images/${piece.color}${piece.type}.png',
        ),
      ),
    );
  }
}
