import 'package:flutter/material.dart';

const BLACK = Color.fromRGBO(100, 133, 68, 1);
const WHITE = Color.fromRGBO(230, 233, 198, 1);

class BoardSquare extends StatelessWidget {
  final int rowIndex;
  final int columnIndex;

  BoardSquare({@required this.columnIndex, @required this.rowIndex});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 8;

    int rowOffset = rowIndex % 2 == 0 ? 1 : 0;
    Color squareColor = (columnIndex + rowOffset) % 2 == 1 ? WHITE : BLACK;

    return Container(
      height: size,
      width: size,
      color: squareColor,
    );
  }
}
