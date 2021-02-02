import 'package:chess/models/position.dart';
import 'package:flutter/material.dart';

class HintMove extends StatelessWidget {
  final Position position;
  final double pieceSize;

  const HintMove({
    @required this.position,
    @required this.pieceSize,
  });

  @override
  Widget build(BuildContext context) {
    double circleSize = pieceSize / 2;

    return Positioned(
      top: position?.y,
      left: position?.x,
      child: Container(
        height: pieceSize,
        width: pieceSize,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circleSize),
              color: Colors.grey.withOpacity(position == null ? 0 : 0.6),
            ),
            height: circleSize,
            width: circleSize,
          ),
        ),
      ),
    );
  }
}
