import 'package:chess/components/board.dart';
import 'package:chess/models/chess.dart';
import 'package:flutter/material.dart';

class ChessApp extends StatelessWidget {
  final Chess chess = Chess();

  @override
  Widget build(BuildContext context) {
    var board = chess.board();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Board(board: board),
      ),
    );
  }
}
