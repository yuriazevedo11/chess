import 'package:chess/models/piece.dart';
import 'package:flutter/material.dart';

class BoardPiece extends StatelessWidget {
  final Piece piece;

  BoardPiece({@required this.piece});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 8;

    return Positioned(
      top: 0,
      left: 0,
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
