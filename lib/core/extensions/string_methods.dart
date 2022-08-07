extension StringMethods on String {
  bool isNumeric() {
    if (this == null) {
      return false;
    }
    return double.parse(this) != null;
  }
}
