class Move {
  String color;
  String from;
  String to;
  String flags;
  String piece;
  String promotion;
  String captured;

  Move({
    this.color,
    this.from,
    this.to,
    this.flags,
    this.piece,
    this.promotion,
    this.captured,
  });

  @override
  String toString() {
    return '{ color: $color, from: $from, to: $to, flags: $flags, piece: $piece, promotion: $promotion, captured: $captured }';
  }
}
