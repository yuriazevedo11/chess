import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        height: size,
        width: size,
        child: Text('Board'),
      ),
    );
  }
}
