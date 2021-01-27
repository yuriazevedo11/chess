import 'package:chess/utils/constants.dart';

class Chess {
  final String fen;
  final rooks = {
    'w': [
      {'square': SQUARES["a1"], 'flag': BITS["QSIDE_CASTLE"]},
      {'square': SQUARES["h1"], 'flag': BITS["KSIDE_CASTLE"]}
    ],
    'b': [
      {'square': SQUARES["a8"], 'flag': BITS["QSIDE_CASTLE"]},
      {'square': SQUARES["h8"], 'flag': BITS["KSIDE_CASTLE"]}
    ]
  };

  var board = List.filled(128, null);
  var kings = {'w': EMPTY, 'b': EMPTY};
  var turn = WHITE;
  var castling = {'w': 0, 'b': 0};
  var ep_square = EMPTY;
  var half_moves = 0;
  var move_number = 1;
  var history = [];
  var header = {};
  var comments = {};

  Chess({this.fen}) {
    if (fen == null) {
      _init(DEFAULT_POSITION);
    } else {
      _init(fen);
    }
  }

  bool _init(String fen, [bool keepHeader]) {
    return true;
  }

  void _reset() {
    _init(DEFAULT_POSITION);
  }
}
