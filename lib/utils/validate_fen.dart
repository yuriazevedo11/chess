import 'package:chess/models/fen_exception.dart';

bool _isNumeric(String s) {
  if (s == null) return false;
  return double.tryParse(s) != null;
}

bool validateFen(String fen) {
  Map<int, String> errors = {
    0: 'No errors.',
    1: 'FEN string must contain six space-delimited fields.',
    2: '6th field (move number) must be a positive integer.',
    3: '5th field (half move counter) must be a non-negative integer.',
    4: '4th field (en-passant square) is invalid.',
    5: '3rd field (castling availability) is invalid.',
    6: '2nd field (side to move) is invalid.',
    7: "1st field (piece positions) does not contain 8 '/'-delimited rows.",
    8: '1st field (piece positions) is invalid [consecutive numbers].',
    9: '1st field (piece positions) is invalid [invalid piece].',
    10: '1st field (piece positions) is invalid [row too large].',
    11: 'Illegal en-passant square',
  };

  var currentElement;

  /* 1st criterion: 6 space-seperated fields? */
  List<String> tokens = fen.split(RegExp(r'\s+'));
  if (tokens.length != 6) {
    throw FenException(errors[1]);
  }

  /* 2nd criterion: move number field is a integer value > 0? */
  currentElement = tokens.elementAt(5);
  if (currentElement == double.nan || int.parse(currentElement) <= 0) {
    throw FenException(errors[2]);
  }

  /* 3rd criterion: half move counter is an integer >= 0? */
  currentElement = tokens.elementAt(4);
  if (currentElement == double.nan || int.parse(currentElement) < 0) {
    throw FenException(errors[3]);
  }

  /* 4th criterion: 4th field is a valid e.p.-string? */
  currentElement = tokens.elementAt(3);
  if (!RegExp(r'^(-|[abcdefgh][36])$').hasMatch(currentElement)) {
    throw FenException(errors[4]);
  }

  /* 5th criterion: 3th field is a valid castle-string? */
  currentElement = tokens.elementAt(2);
  if (!RegExp(r'^(KQ?k?q?|Qk?q?|kq?|q|-)$').hasMatch(currentElement)) {
    throw FenException(errors[5]);
  }

  /* 6th criterion: 2nd field is "w" (white) or "b" (black)? */
  currentElement = tokens.elementAt(1);
  if (!RegExp(r'^(w|b)$').hasMatch(currentElement)) {
    throw FenException(errors[6]);
  }

  /* 7th criterion: 1st field contains 8 rows? */
  List<String> rows = tokens.elementAt(0).split(RegExp(r'/'));
  if (rows.length != 8) {
    throw FenException(errors[7]);
  }

  /* 8th criterion: every row is valid? */
  for (var i = 0; i < rows.length; i++) {
    /* Check for right sum of fields AND not two numbers in succession */
    int sumFields = 0;
    bool previousWasNumber = false;

    for (var k = 0; k < rows[i].length; k++) {
      currentElement = rows[i][k];
      if (_isNumeric(currentElement)) {
        if (previousWasNumber) {
          throw FenException(errors[8]);
        }
        sumFields += int.parse(currentElement);
        previousWasNumber = true;
      } else {
        if (!RegExp(r'^[prnbqkPRNBQK]$').hasMatch(currentElement)) {
          throw FenException(errors[9]);
        }
        sumFields += 1;
        previousWasNumber = false;
      }
    }
    if (sumFields != 8) {
      throw FenException(errors[10]);
    }
  }

  currentElement = tokens.elementAt(3);
  if (currentElement.length > 1 &&
      ((currentElement[1] == '3' && tokens.elementAt(1) == 'w') ||
          (currentElement[1] == '6' && tokens.elementAt(1) == 'b'))) {
    throw FenException(errors[11]);
  }

  return true;
}
