import 'package:chess/models/piece.dart';
import 'package:chess/utils/algebraic.dart';
import 'package:chess/utils/constants.dart';
import 'package:chess/utils/validate_fen.dart';

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

  var board = List<Piece>.filled(128, Piece(type: '', color: ''));
  var kings = {'w': EMPTY, 'b': EMPTY};
  var turn = WHITE;
  var castling = {'w': 0, 'b': 0};
  var epSquare = EMPTY;
  var halfMoves = 0;
  var moveNumber = 1;

  Chess({this.fen}) {
    if (fen == null) {
      _init(DEFAULT_POSITION);
    } else {
      _init(fen);
    }
  }

  bool _init(String fen) {
    List<String> tokens = fen.split(RegExp(r'\s+'));
    String position = tokens[0];
    int square = 0;

    if (!validateFen(fen)) {
      return false;
    }

    _clear();

    for (var i = 0; i < position.length; i++) {
      String piece = position[i];

      if (piece == '/') {
        square += 8;
      } else if ('0123456789'.indexOf(piece) != -1) {
        square += int.parse(piece);
      } else {
        String color = piece.codeUnitAt(0) < 'a'.codeUnitAt(0) ? WHITE : BLACK;
        _put(Piece(type: piece.toLowerCase(), color: color), algebraic(square));
        square++;
      }
    }

    turn = tokens.elementAt(1);

    if (tokens.elementAt(2).indexOf('K') > -1) {
      castling["w"] |= BITS["KSIDE_CASTLE"];
    }
    if (tokens.elementAt(2).indexOf('Q') > -1) {
      castling["w"] |= BITS["QSIDE_CASTLE"];
    }
    if (tokens.elementAt(2).indexOf('k') > -1) {
      castling["b"] |= BITS["KSIDE_CASTLE"];
    }
    if (tokens.elementAt(2).indexOf('q') > -1) {
      castling["b"] |= BITS["QSIDE_CASTLE"];
    }

    epSquare =
        tokens.elementAt(3) == '-' ? EMPTY : SQUARES[tokens.elementAt(3)];
    halfMoves = int.parse(tokens.elementAt(4));
    moveNumber = int.parse(tokens.elementAt(5));

    return true;
  }

  Piece _get(String square) {
    return board[SQUARES[square]];
  }

  bool _put(Piece piece, String square) {
    /* Check for valid piece object */
    if (piece.type == '' && piece.color == '') {
      return false;
    }

    /* Check for piece */
    if (SYMBOLS.indexOf(piece.type.toLowerCase()) == -1) {
      return false;
    }

    /* Check for valid square */
    if (!(SQUARES.containsKey(square))) {
      return false;
    }

    var sq = SQUARES[square];

    /* Don't let the user place more than one king */
    if (piece.type == KING &&
        !(kings[piece.color] == EMPTY || kings[piece.color] == sq)) {
      return false;
    }

    board[sq] = Piece(type: piece.type, color: piece.color);
    if (piece.type == KING) {
      kings[piece.color] = sq;
    }

    return true;
  }

  Piece _remove(String square) {
    Piece piece = _get(square);
    board[SQUARES[square]] = null;

    if (piece.type == KING) {
      kings[piece.color] = EMPTY;
    }

    return piece;
  }

  String _generateFen() {
    int empty = 0;
    String fen = '';

    for (var i = SQUARES["a8"]; i <= SQUARES["h1"]; i++) {
      if (board[i] == null) {
        empty++;
      } else {
        if (empty > 0) {
          fen += empty.toString();
          empty = 0;
        }
        String color = board[i].color;
        String piece = board[i].type;
        fen += color == WHITE ? piece.toUpperCase() : piece.toLowerCase();
      }

      if (((i + 1) & 0x88) != 0) {
        if (empty > 0) {
          fen += empty.toString();
        }

        if (i != SQUARES["h1"]) {
          fen += '/';
        }

        empty = 0;
        i += 8;
      }
    }

    String cflags = '';
    if ((castling[WHITE] & BITS["KSIDE_CASTLE"]) != 0) {
      cflags += 'K';
    }
    if ((castling[WHITE] & BITS["QSIDE_CASTLE"]) != 0) {
      cflags += 'Q';
    }
    if ((castling[BLACK] & BITS["KSIDE_CASTLE"]) != 0) {
      cflags += 'k';
    }
    if ((castling[BLACK] & BITS["QSIDE_CASTLE"]) != 0) {
      cflags += 'q';
    }

    /* Do we have an empty castling flag? */
    if (cflags == '') cflags = '-';
    var epflags = epSquare == EMPTY ? '-' : algebraic(epSquare);

    return [fen, turn, cflags, epflags, halfMoves, moveNumber].join(' ');
  }

  void _clear() {
    board = List.filled(128, null);
    kings = {'w': EMPTY, 'b': EMPTY};
    turn = WHITE;
    castling = {'w': 0, 'b': 0};
    epSquare = EMPTY;
    halfMoves = 0;
    moveNumber = 1;
  }

  void _reset() {
    _init(DEFAULT_POSITION);
  }
}
