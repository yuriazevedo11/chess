import 'package:chess/models/position.dart';
import 'package:chess/utils/dimensions.dart';
import 'package:flutter/material.dart';

class SquareMarker extends StatelessWidget {
  final Position position;
  final Color color;

  const SquareMarker({
    @required this.position,
    @required this.color,
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
