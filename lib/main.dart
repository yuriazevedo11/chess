import 'package:chess/models/chess.dart';
import 'package:chess/models/fen_exception.dart';

void main() {
  try {
    Chess chess = Chess();
    var ascii = chess.ascii();
    print(ascii);
  } on FenException catch (err) {
    print(err.message);
  }
}
