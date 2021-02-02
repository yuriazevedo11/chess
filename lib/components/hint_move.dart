import 'package:chess/models/position.dart';
import 'package:flutter/material.dart';

class HintMove extends StatelessWidget {
  final Position from;
  final double pieceSize;

  const HintMove({
    @required this.from,
    @required this.pieceSize,
  });

  @override
  Widget build(BuildContext context) {
    double circleSize = pieceSize / 2;

    return Positioned(
      top: from?.y,
      left: from?.x,
      child: Container(
        height: pieceSize,
        width: pieceSize,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circleSize),
              color: Colors.grey.withOpacity(from == null ? 0 : 0.5),
            ),
            height: circleSize,
            width: circleSize,
          ),
        ),
      ),
    );
  }
}
