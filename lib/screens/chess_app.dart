import 'package:chess/components/board.dart';
import 'package:chess/components/menu_dialog.dart';
import 'package:chess/models/chess.dart';
import 'package:chess/models/move.dart';
import 'package:chess/models/piece.dart';
import 'package:chess/models/position.dart';
import 'package:chess/utils/constants.dart';
import 'package:chess/utils/notations.dart';
import 'package:flutter/material.dart';

class ChessApp extends StatefulWidget {
  @override
  _ChessAppState createState() => _ChessAppState();
}

class _ChessAppState extends State<ChessApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  static final Chess chess = Chess();
  List<List<Piece>> board;
  String player;
  String inCheck;
  Move lastMove;

  @override
  initState() {
    super.initState();
    board = chess.board();
    player = chess.player;
  }

  bool _isMoveValid(String from, String to) {
    List<Move> moves = chess.possibleMoves();

    Move move = moves.firstWhere(
      (element) => element.from == from && element.to == to,
      orElse: () => null,
    );

    if (move == null) return false;

    chess.movePiece(move);
    _updateBoard();

    return true;
  }

  List<String> _getPossibleMovesFrom(String square) {
    List<Move> moves = chess.possibleMoves();

    List<String> possibleMoves = moves
        .where((move) => move.from == square)
        .map((move) => move.to)
        .toList();

    return possibleMoves;
  }

  void _updateBoard() {
    setState(() {
      board = chess.board();
      player = chess.player;
      lastMove = chess.history.last;

      if (chess.isInCheck()) {
        Piece king = Piece(
          type: KING,
          color: chess.player,
        );

        inCheck = chess.getPiecePositions(king).first;
      } else {
        inCheck = null;
      }
    });
  }

  bool _isSquareOccupied(Position position, double size) {
    String square = positionToSquare(position, size);
    Piece piece = chess.getPiece(square);
    return piece == null ? false : true;
  }

  void _restartGame() {
    chess.reset();
    setState(() {
      board = chess.board();
      player = chess.player;
      inCheck = null;
      lastMove = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: LayoutBuilder(
          builder: (ctx, constraints) {
            return Board(
              board: board,
              player: player,
              inCheck: inCheck,
              isMoveValid: _isMoveValid,
              getPossibleMovesFrom: _getPossibleMovesFrom,
              isSquareOccupied: _isSquareOccupied,
              lastMove: lastMove,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final navigatorContext = navigatorKey.currentState.overlay.context;
            showDialog(
              context: navigatorContext,
              builder: (ctx) => MenuDialog(restartGame: _restartGame),
            );
          },
          child: Icon(Icons.menu),
          backgroundColor: Colors.blueGrey,
        ),
      ),
    );
  }
}
