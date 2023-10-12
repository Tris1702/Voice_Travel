class InputFormatter {
  String formatString(String input) {
    return input.replaceAll("  ", "");
  }

  List<String> splitSentenceToWords(String sentence) {
    return sentence.split(RegExp(r"[,;.:?!]"));
  }
}