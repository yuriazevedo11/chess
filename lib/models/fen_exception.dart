class FenException implements Exception {
  final String message;
  FenException(this.message);

  @override
  String toString() {
    return '[Invalid FEN] $message';
  }
}
