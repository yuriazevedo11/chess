import 'package:chess/models/position.dart';
import 'package:flutter/material.dart';

class SquareMarker extends StatelessWidget {
  final Position from;
  final double pieceSize;

  const SquareMarker({
    @required this.from,
    @required this.pieceSize,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: from?.y,
      left: from?.x,
      child: Container(
        height: pieceSize,
        width: pieceSize,
        color: Colors.yellow[300].withOpacity(from == null ? 0 : 0.5),
      ),
    );
  }
}
