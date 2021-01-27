dynamic rank(int i) {
  return i >> 4;
}

dynamic file(int i) {
  return i & 15;
}

String algebraic(int i) {
  var f = file(i);
  var r = rank(i);
  return 'abcdefgh'.substring(f, f + 1) + '87654321'.substring(r, r + 1);
}
