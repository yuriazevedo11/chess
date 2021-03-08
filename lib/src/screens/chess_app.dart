import 'package:chess/src/components/board.dart';
import 'package:chess/src/controllers/app_controller.dart';
import 'package:flutter/material.dart';

class ChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController(),
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: AppController.navigatorKey,
          home: Scaffold(
            backgroundColor: Colors.grey[900],
            body: LayoutBuilder(builder: (ctx, constraints) => Board()),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.menu),
              backgroundColor: Colors.blueGrey,
              onPressed: AppController().openMenu,
            ),
          ),
        );
      },
    );
  }
}
