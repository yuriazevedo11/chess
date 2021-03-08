import 'package:flutter/material.dart';

Size getScreenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double getBoardSize(BuildContext context) {
  return getScreenSize(context).width;
}

double getSquareSize(BuildContext context) {
  return getBoardSize(context) / 8;
}
