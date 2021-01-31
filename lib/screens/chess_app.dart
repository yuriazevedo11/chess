import 'package:chess/components/board.dart';
import 'package:chess/models/chess.dart';
import 'package:chess/models/piece.dart';
import 'package:flutter/material.dart';

class ChessApp extends StatefulWidget {
  @override
  _ChessAppState createState() => _ChessAppState();
}

class _ChessAppState extends State<ChessApp> {
  static final Chess chess = Chess();
  List<List<Piece>> board;

  @override
  initState() {
    super.initState();
    board = chess.board();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Board(board: board),
      ),
    );
  }
}
