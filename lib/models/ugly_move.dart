class UglyMove {
  final String color;
  final int from;
  final int to;
  final int flags;
  final String piece;
  final String promotion;
  final String captured;

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

  set to(int to) {
    this.to = to;
  }

  set from(int from) {
    this.from = from;
  }

  set flags(int flags) {
    this.flags = flags;
  }

  set promotion(String promotion) {
    this.promotion = promotion;
  }

  set captured(String captured) {
    this.captured = captured;
  }
}
