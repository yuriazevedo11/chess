import 'package:chess/models/position.dart';
import 'package:flutter/material.dart';

class SquareMarker extends StatelessWidget {
  final Position position;
  final double pieceSize;

  const SquareMarker({
    @required this.position,
    @required this.pieceSize,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position?.y,
      left: position?.x,
      child: Container(
        height: pieceSize,
        width: pieceSize,
        color: Colors.yellow[300].withOpacity(position == null ? 0 : 0.5),
      ),
    );
  }
}