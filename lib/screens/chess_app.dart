import 'package:chess/components/board.dart';
import 'package:flutter/material.dart';

class ChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Board(),
      ),
    );
  }
}
