import 'package:flutter/material.dart';

const BLACK = Color(0xFFB0BEC5);
const WHITE = Color(0xFFFFFFFF);

class BoardSquare extends StatelessWidget {
  final int rowIndex;
  final int columnIndex;

  BoardSquare({@required this.columnIndex, @required this.rowIndex});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 8;
    int rowOffset = rowIndex % 2 == 0 ? 1 : 0;
    bool isWhite = (columnIndex + rowOffset) % 2 == 1;

    Color squareColor = isWhite ? WHITE : BLACK;
    Color textColor = isWhite ? BLACK : WHITE;

    return Container(
      height: size,
      width: size,
      color: squareColor,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  (8 - columnIndex).toString(),
                  style: TextStyle(
                    color: textColor.withAlpha(rowIndex == 0 ? 255 : 0),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  String.fromCharCode('a'.codeUnits[0] + rowIndex),
                  style: TextStyle(
                    color: textColor.withAlpha(columnIndex == 7 ? 255 : 0),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
