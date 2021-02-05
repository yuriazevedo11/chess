import 'package:chess/components/board.dart';
import 'package:chess/models/chess.dart';
import 'package:chess/models/move.dart';
import 'package:chess/models/piece.dart';
import 'package:chess/utils/constants.dart';
import 'package:flutter/material.dart';

class ChessApp extends StatefulWidget {
  @override
  _ChessAppState createState() => _ChessAppState();
}

class _ChessAppState extends State<ChessApp> {
  static final Chess chess = Chess();
  List<List<Piece>> board;
  String player;
  String inCheck;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: LayoutBuilder(
          builder: (ctx, constraints) {
            return Board(
              board: board,
              player: player,
              isMoveValid: _isMoveValid,
              getPossibleMovesFrom: _getPossibleMovesFrom,
              inCheck: inCheck,
            );
          },
        ),
      ),
    );
  }
}
