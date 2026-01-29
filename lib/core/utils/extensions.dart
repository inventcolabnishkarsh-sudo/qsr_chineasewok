extension StringX on String {
  bool get isEmail => contains('@') && contains('.');
}
