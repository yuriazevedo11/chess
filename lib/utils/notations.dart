import 'package:chess/models/position.dart';

String positionToSquare(Position gesturePosition, double size) {
  String column = String.fromCharCode(
    'a'.codeUnits[0] + (gesturePosition.x / size).round(),
  );
  String row = (8 - (gesturePosition.y / size).round()).toString();

  return column + row;
}

Position squareToPosision(String square, double size) {
  List<String> tokens = square.split('');
  String column = tokens[0];
  String row = tokens[1];

  if (tokens.length > 2 || column == null || row == null) {
    throw Error();
  }

  var indexes = {
    'x': column.codeUnits[0] - 'a'.codeUnits[0],
    'y': int.parse(row) - 1,
  };

  return Position(
    x: indexes['x'] * size,
    y: 7 * size - indexes['y'] * size,
  );
}
