class UglyMove {
  String color;
  int from;
  int to;
  int flags;
  String piece;
  String promotion;
  String captured;

  UglyMove({
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
