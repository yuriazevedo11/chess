import 'package:chess/models/position.dart';
import 'package:chess/utils/dimensions.dart';
import 'package:chess/utils/notations.dart';
import 'package:flutter/material.dart';

class HintMove extends StatelessWidget {
  final Position position;
  final void Function(String to, double size) moveFromHint;

  const HintMove({
    @required this.position,
    @required this.moveFromHint,
  });

  @override
  Widget build(BuildContext context) {
    double outerCircleSize = getSquareSize(context);
    double innerCircleSize = outerCircleSize / 2.5;

    Color color = Colors.grey.withOpacity(position == null ? 0 : 0.6);
    BorderRadius borderRadius = BorderRadius.circular(outerCircleSize);

    return Positioned(
      top: position?.y,
      left: position?.x,
      child: GestureDetector(
        onTap: () {
          String squareTo = positionToSquare(position, outerCircleSize);
          moveFromHint(squareTo, outerCircleSize);
        },
        child: Container(
          height: outerCircleSize,
          width: outerCircleSize,
          decoration: BoxDecoration(
            border: Border.all(
              width: 4.0,
              color: color,
            ),
            borderRadius: borderRadius,
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: color,
              ),
              height: innerCircleSize,
              width: innerCircleSize,
            ),
          ),
        ),
      ),
    );
  }
}
