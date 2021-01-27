class Move {
  final String color;
  final int from;
  final int to;
  final int flags;
  final String piece;
  final String promotion;
  final String captured;

  Move({
    this.color,
    this.from,
    this.to,
    this.flags,
    this.piece,
    this.promotion,
    this.captured,
  });

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
