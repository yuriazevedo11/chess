import 'package:chess/src/controllers/app_controller.dart';
import 'package:chess/src/models/position.dart';
import 'package:chess/src/utils/dimensions.dart';
import 'package:chess/src/utils/notations.dart';
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
    bool squareHasPiece =
        AppController.instance.isSquareOccupied(position, outerCircleSize);
    double innerCircleSize = outerCircleSize / (squareHasPiece ? 1 : 2);

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
            border: squareHasPiece
                ? Border.all(
                    width: 4.0,
                    color: color,
                  )
                : null,
            borderRadius: borderRadius,
          ),
          child: Center(
            child: Container(
              decoration: !squareHasPiece
                  ? BoxDecoration(
                      borderRadius: borderRadius,
                      color: color,
                    )
                  : null,
              height: innerCircleSize,
              width: innerCircleSize,
            ),
          ),
        ),
      ),
    );
  }
}
