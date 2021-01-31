class Piece {
  String type;
  final String color;

  Piece({this.type, this.color});

  @override
  String toString() {
    return '{ type: $type, color: $color }';
  }
}
