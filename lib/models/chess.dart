import 'package:chess/models/history.dart';
import 'package:chess/models/move.dart';
import 'package:chess/models/piece.dart';
import 'package:chess/models/ugly_move.dart';
import 'package:chess/utils/algebraic.dart';
import 'package:chess/utils/constants.dart';
import 'package:chess/utils/validate_fen.dart';

class Chess {
  final String _fen;
  final _rooks = {
    'w': [
      {'square': SQUARES["a1"], 'flag': BITS["QSIDE_CASTLE"]},
      {'square': SQUARES["h1"], 'flag': BITS["KSIDE_CASTLE"]}
    ],
    'b': [
      {'square': SQUARES["a8"], 'flag': BITS["QSIDE_CASTLE"]},
      {'square': SQUARES["h8"], 'flag': BITS["KSIDE_CASTLE"]}
    ]
  };

  var _board = List<Piece>.filled(128, null);
  var _kings = {'w': EMPTY, 'b': EMPTY};
  String _turn = WHITE;
  var _castling = {'w': 0, 'b': 0};
  int _epSquare = EMPTY;
  int _halfMoves = 0;
  int _moveNumber = 1;
  List<History> _history = [];

  Chess([this._fen]) {
    if (_fen == null) {
      _init(DEFAULT_POSITION);
    } else {
      _init(_fen);
    }
  }

  String get fen {
    return _generateFen();
  }

  String get player {
    return _turn;
  }

  void reset() {
    _init(DEFAULT_POSITION);
  }

  bool _init(String fen) {
    List<String> tokens = fen.split(RegExp(r'\s+'));
    String position = tokens[0];
    int square = 0;

    if (!validateFen(fen)) {
      return false;
    }

    _clear();

    for (int i = 0; i < position.length; i++) {
      String piece = position[i];

      if (piece == '/') {
        square += 8;
      } else if ('0123456789'.indexOf(piece) != -1) {
        square += int.parse(piece);
      } else {
        String color = piece.codeUnitAt(0) < 'a'.codeUnitAt(0) ? WHITE : BLACK;
        putPiece(
          Piece(type: piece.toLowerCase(), color: color),
          algebraic(square),
        );
        square++;
      }
    }

    _turn = tokens.elementAt(1);

    if (tokens.elementAt(2).indexOf('K') > -1) {
      _castling["w"] |= BITS["KSIDE_CASTLE"];
    }
    if (tokens.elementAt(2).indexOf('Q') > -1) {
      _castling["w"] |= BITS["QSIDE_CASTLE"];
    }
    if (tokens.elementAt(2).indexOf('k') > -1) {
      _castling["b"] |= BITS["KSIDE_CASTLE"];
    }
    if (tokens.elementAt(2).indexOf('q') > -1) {
      _castling["b"] |= BITS["QSIDE_CASTLE"];
    }

    _epSquare =
        tokens.elementAt(3) == '-' ? EMPTY : SQUARES[tokens.elementAt(3)];
    _halfMoves = int.parse(tokens.elementAt(4));
    _moveNumber = int.parse(tokens.elementAt(5));

    return true;
  }

  List<List<Piece>> board() {
    List<List<Piece>> output = [];
    List<Piece> row = [];

    for (int i = SQUARES["a8"]; i <= SQUARES["h1"]; i++) {
      if (_board[i] == null) {
        row.add(null);
      } else {
        row.add(Piece(type: _board[i].type, color: _board[i].color));
      }
      if (((i + 1) & 0x88) != 0) {
        output.add(row);
        row = [];
        i += 8;
      }
    }

    return output;
  }

  void _clear() {
    _board = List.filled(128, null);
    _kings = {'w': EMPTY, 'b': EMPTY};
    _turn = WHITE;
    _castling = {'w': 0, 'b': 0};
    _epSquare = EMPTY;
    _halfMoves = 0;
    _moveNumber = 1;
    _history = [];
  }

  UglyMove _buildMove(
    List<Piece> board,
    int from,
    int to,
    int flags, [
    String promotion,
  ]) {
    UglyMove move = UglyMove(
      color: _turn,
      from: from,
      to: to,
      flags: flags,
      piece: board[from].type,
    );

    if (promotion != null && promotion != '') {
      move.flags |= BITS["PROMOTION"];
      move.promotion = promotion;
    }

    if (board[to] != null) {
      move.captured = board[to].type;
    } else if ((flags & BITS["EP_CAPTURE"]) != 0) {
      move.captured = PAWN;
    }

    return move;
  }

  bool _attacked(String color, int square) {
    for (int i = SQUARES["a8"]; i <= SQUARES["h1"]; i++) {
      /* Did we run off the end of the board? */
      if ((i & 0x88) != 0) {
        i += 7;
        continue;
      }

      /* If empty square or wrong color */
      if (_board[i] == null || _board[i].color != color) continue;

      Piece piece = _board[i];
      int difference = i - square;
      int index = difference + 119;

      if ((ATTACKS[index] & (1 << SHIFTS[piece.type])) != 0) {
        if (piece.type == PAWN) {
          if (difference > 0) {
            if (piece.color == WHITE) return true;
          } else {
            if (piece.color == BLACK) return true;
          }
          continue;
        }

        /* If the piece is a knight or a king */
        if (piece.type == 'n' || piece.type == 'k') return true;

        int offset = RAYS[index];
        int j = i + offset;

        bool blocked = false;
        while (j != square) {
          if (_board[j] != null) {
            blocked = true;
            break;
          }
          j += offset;
        }

        if (!blocked) return true;
      }
    }

    return false;
  }

  void _makeMove(UglyMove move) {
    String us = _turn;
    String them = _swapColor(us);
    _pushToHistory(move);

    _board[move.to] = _board[move.from];
    _board[move.from] = null;

    /* If ep capture, remove the captured pawn */
    if ((move.flags & BITS["EP_CAPTURE"]) != 0) {
      if (_turn == BLACK) {
        _board[move.to - 16] = null;
      } else {
        _board[move.to + 16] = null;
      }
    }

    /* If pawn promotion, replace with new piece */
    if ((move.flags & BITS["PROMOTION"]) != 0) {
      _board[move.to] = Piece(type: move.promotion, color: us);
    }

    /* If we moved the king */
    if (_board[move.to] != null && _board[move.to].type == KING) {
      _kings[_board[move.to].color] = move.to;

      /* If we castled, move the rook next to the king */
      if ((move.flags & BITS["KSIDE_CASTLE"]) != 0) {
        int castlingTo = move.to - 1;
        int castlingFrom = move.to + 1;
        _board[castlingTo] = _board[castlingFrom];
        _board[castlingFrom] = null;
      } else if ((move.flags & BITS["QSIDE_CASTLE"]) != 0) {
        int castlingTo = move.to + 1;
        int castlingFrom = move.to - 2;
        _board[castlingTo] = _board[castlingFrom];
        _board[castlingFrom] = null;
      }

      /* Turn off castling */
      _castling[us] = -1;
    }

    /* Turn off castling if we move a rook */
    if (_castling[us] > 0) {
      for (int i = 0, len = _rooks[us].length; i < len; i++) {
        if (move.from == _rooks[us][i]["square"] &&
            ((_castling[us] & _rooks[us][i]["flag"]) != 0)) {
          _castling[us] ^= _rooks[us][i]["flag"];
          break;
        }
      }
    }

    /* Turn off castling if we capture a rook */
    if (_castling[them] > 0) {
      for (int i = 0, len = _rooks[them].length; i < len; i++) {
        if (move.to == _rooks[them][i]["square"] &&
            ((_castling[them] & _rooks[them][i]["flag"]) != 0)) {
          _castling[them] ^= _rooks[them][i]["flag"];
          break;
        }
      }
    }

    /* If big pawn move, update the en passant square */
    if ((move.flags & BITS["BIG_PAWN"]) != 0) {
      if (_turn == 'b') {
        _epSquare = move.to - 16;
      } else {
        _epSquare = move.to + 16;
      }
    } else {
      _epSquare = EMPTY;
    }

    /* Reset the 50 move counter if a pawn is moved or a piece is captured */
    if (move.piece == PAWN) {
      _halfMoves = 0;
    } else if ((move.flags & (BITS["CAPTURE"] | BITS["EP_CAPTURE"])) != 0) {
      _halfMoves = 0;
    } else {
      _halfMoves++;
    }

    if (_turn == BLACK) {
      _moveNumber++;
    }

    _turn = _swapColor(_turn);
  }

  Move _makePretty(UglyMove uglyMove) {
    String flags = '';

    for (String flag in BITS.keys) {
      if ((BITS[flag] & uglyMove.flags) != 0) {
        flags += FLAGS[flag];
      }
    }

    Move move = Move(
      captured: uglyMove.captured,
      color: uglyMove.color,
      piece: uglyMove.piece,
      promotion: uglyMove.promotion,
      to: algebraic(uglyMove.to),
      from: algebraic(uglyMove.from),
      flags: flags,
    );

    return move;
  }

  List<UglyMove> _generateMoves([dynamic options]) {
    _addMove(
      List<Piece> board,
      List<UglyMove> moves,
      int from,
      int to,
      int flags,
    ) {
      /* If pawn promotion */
      if (board[from].type == PAWN &&
          (rank(to) == RANK_8 || rank(to) == RANK_1)) {
        List<String> pieces = [QUEEN, ROOK, BISHOP, KNIGHT];
        for (int i = 0, len = pieces.length; i < len; i++) {
          moves.add(_buildMove(board, from, to, flags, pieces[i]));
        }
      } else {
        moves.add(_buildMove(board, from, to, flags));
      }
    }

    List<UglyMove> moves = [];
    String us = _turn;
    String them = _swapColor(us);
    var secondRank = {'b': RANK_7, 'w': RANK_2};

    int firstSq = SQUARES["a8"];
    int lastSq = SQUARES["h1"];
    bool singleSquare = false;

    /* Do we want legal moves? */
    bool legal =
        options == null || options["legal"] == null ? true : options["legal"];

    /* Are we generating moves for a single square? */
    if (options != null && options["square"] != null) {
      if (SQUARES.containsKey(options["square"])) {
        firstSq = lastSq = SQUARES[options.square];
        singleSquare = true;
      } else {
        /* Invalid square */
        return [];
      }
    }

    for (int i = firstSq; i <= lastSq; i++) {
      /* Did we run off the end of the board? */
      if ((i & 0x88) != 0) {
        i += 7;
        continue;
      }

      Piece piece = _board[i];
      if (piece == null || piece.color != us) {
        continue;
      }

      if (piece.type == PAWN) {
        /* Single square, non-capturing */
        int square = i + PAWN_OFFSETS[us][0];
        if (_board[square] == null) {
          _addMove(_board, moves, i, square, BITS["NORMAL"]);

          /* Double square */
          int doubleSquare = i + PAWN_OFFSETS[us][1];
          if (secondRank[us] == rank(i) && _board[doubleSquare] == null) {
            _addMove(_board, moves, i, doubleSquare, BITS["BIG_PAWN"]);
          }
        }

        /* Pawn captures */
        for (int j = 2; j < 4; j++) {
          int square = i + PAWN_OFFSETS[us][j];
          if ((square & 0x88) != 0) continue;

          if (_board[square] != null && _board[square].color == them) {
            _addMove(_board, moves, i, square, BITS["CAPTURE"]);
          } else if (square == _epSquare) {
            _addMove(_board, moves, i, _epSquare, BITS["EP_CAPTURE"]);
          }
        }
      } else {
        for (int j = 0, len = PIECE_OFFSETS[piece.type].length; j < len; j++) {
          int offset = PIECE_OFFSETS[piece.type][j];
          int square = i;

          while (true) {
            square += offset;
            if ((square & 0x88) != 0) break;

            if (_board[square] == null) {
              _addMove(_board, moves, i, square, BITS["NORMAL"]);
            } else {
              if (_board[square].color == us) break;
              _addMove(_board, moves, i, square, BITS["CAPTURE"]);
              break;
            }

            /* Break, if knight or king */
            if (piece.type == 'n' || piece.type == 'k') break;
          }
        }
      }
    }

    /* Check for castling if:
     * a) it's turned on;
     * b) we're generating all moves, and
     * c) we're doing single square move generation on the king's square
     */
    if (_castling[us] != -1 && (!singleSquare || lastSq == _kings[us])) {
      /* King-side castling */
      if ((_castling[us] & BITS["KSIDE_CASTLE"]) != 0) {
        int castlingFrom = _kings[us];
        int castlingTo = castlingFrom + 2;

        if (_board[castlingFrom + 1] == null &&
            _board[castlingTo] == null &&
            !_attacked(them, _kings[us]) &&
            !_attacked(them, castlingFrom + 1) &&
            !_attacked(them, castlingTo)) {
          _addMove(_board, moves, _kings[us], castlingTo, BITS["KSIDE_CASTLE"]);
        }
      }

      /* Queen-side castling */
      if ((_castling[us] & BITS["QSIDE_CASTLE"]) != 0) {
        int castlingFrom = _kings[us];
        int castlingTo = castlingFrom - 2;

        if (_board[castlingFrom - 1] == null &&
            _board[castlingFrom - 2] == null &&
            _board[castlingFrom - 3] == null &&
            !_attacked(them, _kings[us]) &&
            !_attacked(them, castlingFrom - 1) &&
            !_attacked(them, castlingTo)) {
          _addMove(_board, moves, _kings[us], castlingTo, BITS["QSIDE_CASTLE"]);
        }
      }
    }

    /* Return all pseudo-legal moves (this includes moves that allow the king to be captured) */
    if (!legal) {
      return moves;
    }

    /* Filter out illegal moves */
    List<UglyMove> legalMoves = [];
    for (int i = 0, len = moves.length; i < len; i++) {
      _makeMove(moves[i]);
      if (!_kingAttacked(us)) {
        legalMoves.add(moves[i]);
      }
      _undoMove();
    }

    return legalMoves;
  }

  List<Move> possibleMoves([dynamic options]) {
    /* The internal representation of a chess move is in 0x88 format, and
      * not meant to be human-readable. The code below converts the 0x88
      * square coordinates to algebraic coordinates. It also prunes an
      * unnecessary move keys.
    */

    List<UglyMove> uglyMoves = _generateMoves(options);
    List<Move> moves = [];

    for (int i = 0, len = uglyMoves.length; i < len; i++) {
      moves.add(_makePretty(uglyMoves[i]));
    }

    return moves;
  }

  Move movePiece(Move move, [dynamic options]) {
    UglyMove moveObj;

    List<UglyMove> moves = _generateMoves(options);

    /* Convert the pretty move object to an ugly move object */
    for (int i = 0, len = moves.length; i < len; i++) {
      if (move.from == algebraic(moves[i].from) &&
          move.to == algebraic(moves[i].to) &&
          move.promotion == moves[i].promotion) {
        moveObj = moves[i];
        break;
      }
    }

    /* Failed to find move */
    if (moveObj == null) {
      return null;
    }

    Move prettyMove = _makePretty(moveObj);

    _makeMove(moveObj);

    return prettyMove;
  }

  UglyMove _undoMove() {
    History old = _history.removeLast();

    if (old == null) {
      return null;
    }

    UglyMove move = old.move;
    _kings = old.kings;
    _turn = old.turn;
    _castling = old.castling;
    _epSquare = old.epSquare;
    _halfMoves = old.halfMoves;
    _moveNumber = old.moveNumber;

    String us = _turn;
    String them = _swapColor(_turn);

    _board[move.from] = _board[move.to];
    _board[move.from].type = move.piece; // Undo any promotions
    _board[move.to] = null;

    if ((move.flags & BITS["CAPTURE"]) != 0) {
      _board[move.to] = Piece(type: move.captured, color: them);
    } else if ((move.flags & BITS["EP_CAPTURE"]) != 0) {
      int index;
      if (us == BLACK) {
        index = move.to - 16;
      } else {
        index = move.to + 16;
      }
      _board[index] = Piece(type: PAWN, color: them);
    }

    if ((move.flags & (BITS["KSIDE_CASTLE"] | BITS["QSIDE_CASTLE"])) != 0) {
      int castlingTo, castlingFrom;
      if ((move.flags & BITS["KSIDE_CASTLE"]) != 0) {
        castlingTo = move.to + 1;
        castlingFrom = move.to - 1;
      } else if ((move.flags & BITS["QSIDE_CASTLE"]) != 0) {
        castlingTo = move.to - 2;
        castlingFrom = move.to + 1;
      }

      _board[castlingTo] = _board[castlingFrom];
      _board[castlingFrom] = null;
    }

    return move;
  }

  void _pushToHistory(UglyMove move) {
    _history.add(
      History(
        move: move,
        kings: {'b': _kings["b"], 'w': _kings["w"]},
        turn: _turn,
        castling: {'b': _castling["b"], 'w': _castling["w"]},
        epSquare: _epSquare,
        halfMoves: _halfMoves,
        moveNumber: _moveNumber,
      ),
    );
  }

  Piece getPiece(String square) {
    return _board[SQUARES[square]];
  }

  bool putPiece(Piece piece, String square) {
    if (piece == null) return false;

    /* Check for piece */
    if (SYMBOLS.indexOf(piece.type.toLowerCase()) == -1) {
      return false;
    }

    /* Check for valid square */
    if (!(SQUARES.containsKey(square))) {
      return false;
    }

    int sq = SQUARES[square];

    /* Don't let the user place more than one king */
    if (piece.type == KING &&
        !(_kings[piece.color] == EMPTY || _kings[piece.color] == sq)) {
      return false;
    }

    _board[sq] = Piece(type: piece.type, color: piece.color);
    if (piece.type == KING) {
      _kings[piece.color] = sq;
    }

    return true;
  }

  Piece removePiece(String square) {
    Piece piece = getPiece(square);
    _board[SQUARES[square]] = null;

    if (piece.type == KING) {
      _kings[piece.color] = EMPTY;
    }

    return piece;
  }

  String ascii() {
    String output = '   +------------------------+\n';

    for (int i = SQUARES["a8"]; i <= SQUARES["h1"]; i++) {
      /* Display the rank */
      if (file(i) == 0) {
        output += ' ' + '87654321'[rank(i)] + ' |';
      }

      /* Empty piece */
      if (_board[i] == null) {
        output += ' . ';
      } else {
        String piece = _board[i].type;
        String color = _board[i].color;
        String symbol =
            color == WHITE ? piece.toUpperCase() : piece.toLowerCase();
        output += ' ' + symbol + ' ';
      }

      if (((i + 1) & 0x88) != 0) {
        output += '|\n';
        i += 8;
      }
    }
    output += '   +------------------------+\n';
    output += '     a  b  c  d  e  f  g  h\n';

    return output;
  }

  List<String> getPiecePositions(Piece piece) {
    List<int> boardIndexes = [];
    List<Piece> flatten = board().expand((element) => element).toList();

    flatten.asMap().forEach((index, element) {
      if (element?.color == piece.color && element?.type == piece.type) {
        boardIndexes.add(index);
      }
    });

    List<String> squares = boardIndexes.map((pieceIndex) {
      String row = 'abcdefgh'[pieceIndex % 8];
      int column = ((64 - pieceIndex) / 8).ceil();
      return row + column.toString();
    }).toList();

    return squares;
  }

  String _generateFen() {
    int empty = 0;
    String fen = '';

    for (int i = SQUARES["a8"]; i <= SQUARES["h1"]; i++) {
      if (_board[i] == null) {
        empty++;
      } else {
        if (empty > 0) {
          fen += empty.toString();
          empty = 0;
        }
        String color = _board[i].color;
        String piece = _board[i].type;

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
    if ((_castling[WHITE] & BITS["KSIDE_CASTLE"]) != 0) {
      cflags += 'K';
    }
    if ((_castling[WHITE] & BITS["QSIDE_CASTLE"]) != 0) {
      cflags += 'Q';
    }
    if ((_castling[BLACK] & BITS["KSIDE_CASTLE"]) != 0) {
      cflags += 'k';
    }
    if ((_castling[BLACK] & BITS["QSIDE_CASTLE"]) != 0) {
      cflags += 'q';
    }

    /* Do we have an empty castling flag? */
    cflags = cflags ?? '-';
    String epflags = _epSquare == EMPTY ? '-' : algebraic(_epSquare);

    return [fen, _turn, cflags, epflags, _halfMoves, _moveNumber].join(' ');
  }

  String _swapColor(String color) {
    return color == WHITE ? BLACK : WHITE;
  }

  _kingAttacked(String color) {
    return _attacked(_swapColor(color), _kings[color]);
  }

  bool isInCheck() {
    return _kingAttacked(_turn);
  }

  bool isInCheckmate() {
    return isInCheck() && _generateMoves().length == 0;
  }

  bool _isInStalemate() {
    return !isInCheck() && _generateMoves().length == 0;
  }

  bool isInDraw() {
    return _halfMoves >= 100 ||
        _isInStalemate() ||
        _insufficientMaterial() ||
        _inThreefoldRepetition();
  }

  bool isInGameOver() {
    return isInCheckmate() || isInDraw();
  }

  bool _insufficientMaterial() {
    var pieces = {};
    List<int> bishops = [];
    int numPieces = 0;
    int squareColor = 0;

    for (int i = SQUARES['a8']; i <= SQUARES['h1']; i++) {
      squareColor = (squareColor + 1) % 2;
      if ((i & 0x88) != 0) {
        i += 7;
        continue;
      }

      Piece piece = _board[i];
      if (piece != null) {
        String type = piece.type;
        pieces[piece.type] = pieces.containsKey(type) ? pieces[type] + 1 : 1;
        if (type == BISHOP) {
          bishops.add(squareColor);
        }
        numPieces++;
      }
    }

    /* k vs. k */
    if (numPieces == 2) {
      return true;
    } else if (
        /* k vs. kn .... or .... k vs. kb */
        numPieces == 3 && (pieces[BISHOP] == 1 || pieces[KNIGHT] == 1)) {
      return true;
    } else if (numPieces == pieces[BISHOP] + 2) {
      /* kb vs. kb where any number of bishops are all on the same color */
      int sum = 0;
      int len = bishops.length;
      for (int i = 0; i < len; i++) {
        sum += bishops[i];
      }
      if (sum == 0 || sum == len) {
        return true;
      }
    }

    return false;
  }

  bool _inThreefoldRepetition() {
    List<UglyMove> moves = [];
    var positions = {};
    bool repetition = false;

    while (true) {
      UglyMove move = _undoMove();
      if (move != null) break;
      moves.add(move);
    }

    while (true) {
      /* Remove the last two fields in the FEN string, they're not needed when checking for draw by rep */
      String fen = _generateFen().split(' ').getRange(0, 4).join(' ');

      /* Has the position occurred three or move times? */
      positions[fen] = positions.containsKey(fen) ? positions[fen] + 1 : 1;
      if (positions[fen] >= 3) {
        repetition = true;
      }

      if (moves.length == 0) {
        break;
      }
      _makeMove(moves.removeLast());
    }

    return repetition;
  }
}
