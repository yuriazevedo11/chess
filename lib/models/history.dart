import 'package:chess/models/ugly_move.dart';

class History {
  UglyMove move;
  Map<String, int> kings;
  String turn;
  Map<String, int> castling;
  int epSquare;
  int halfMoves;
  int moveNumber;

  History({
    this.move,
    this.kings,
    this.turn,
    this.castling,
    this.epSquare,
    this.halfMoves,
    this.moveNumber,
  });

  @override
  String toString() {
    return '{ move: $move, kings: $kings, turn: $turn, castling: $castling, epSquare: $epSquare, halfMoves: $halfMoves, moveNumber: $moveNumber }';
  }
}
