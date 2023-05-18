class ParseFunctions {
  static String getDate({required DateTime date}) {
    String myDate = "${date.day}/${date.month}/${date.year}";
    return myDate;
  }
}
