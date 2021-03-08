import 'package:chess/src/components/menu_dialog.dart';
import 'package:chess/src/models/move.dart';
import 'package:chess/src/models/piece.dart';
import 'package:chess/src/models/position.dart';
import 'package:chess/src/utils/constants.dart';
import 'package:chess/src/utils/notations.dart';
import 'package:flutter/material.dart';

import 'chess_controller.dart';

class AppController extends ChangeNotifier {
  static final instance = AppController();
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final ChessController _chess = ChessController();

  List<List<Piece>> board;
  String player;
  String inCheck;
  Move lastMove;

  AppController() {
    board = _chess.board();
    player = _chess.player;
  }

  bool isMoveValid(String from, String to) {
    List<Move> moves = _chess.possibleMoves();

    Move move = moves.firstWhere(
      (element) => element.from == from && element.to == to,
      orElse: () => null,
    );

    if (move == null) return false;

    _chess.movePiece(move);
    _updateBoard();

    return true;
  }

  List<String> getPossibleMovesFrom(String square) {
    List<Move> moves = _chess.possibleMoves();

    List<String> possibleMoves = moves
        .where((move) => move.from == square)
        .map((move) => move.to)
        .toList();

    return possibleMoves;
  }

  bool isSquareOccupied(Position position, double size) {
    String square = positionToSquare(position, size);
    Piece piece = _chess.getPiece(square);
    return piece == null ? false : true;
  }

  void openMenu({String title, bool dismissible = true}) {
    final navigatorContext = navigatorKey.currentState.overlay.context;
    showDialog(
      context: navigatorContext,
      barrierDismissible: dismissible,
      builder: (ctx) => MenuDialog(
        title: title,
        restartGame: _restartGame,
      ),
    );
  }

  void _updateBoard() {
    board = _chess.board();
    player = _chess.player;
    lastMove = _chess.history.last;

    if (_chess.isInGameOver()) {
      String title;

      if (_chess.isInDraw()) {
        title = 'Draw 😑';
      } else if (player == WHITE) {
        title = 'You lose 😞';
      } else {
        title = 'You win 🎉';
      }

      openMenu(title: title, dismissible: false);
    } else if (_chess.isInCheck()) {
      Piece king = Piece(
        type: KING,
        color: _chess.player,
      );

      inCheck = _chess.getPiecePositions(king).first;
    } else {
      inCheck = null;
    }

    notifyListeners();
  }

  void _restartGame() {
    _chess.reset();
    board = _chess.board();
    player = _chess.player;
    inCheck = null;
    lastMove = null;
    notifyListeners();
  }
}
