import 'package:chess/src/models/position.dart';
import 'package:chess/src/utils/dimensions.dart';
import 'package:flutter/material.dart';

const DEFAULT_COLOR = Color(0xFF64b5f6);

class SquareMarker extends StatelessWidget {
  final Position position;
  final Color color;

  SquareMarker({
    @required this.position,
    this.color = DEFAULT_COLOR,
  });

  @override
  Widget build(BuildContext context) {
    double size = getSquareSize(context);

    return Positioned(
      top: position?.y,
      left: position?.x,
      child: Container(
        height: size,
        width: size,
        color: color.withOpacity(position == null ? 0 : 0.5),
      ),
    );
  }
}
