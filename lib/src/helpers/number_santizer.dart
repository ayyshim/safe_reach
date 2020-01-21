class NumberSanitizer {
  static String sanitize(String number) {
    var converted = number.split("(").join("");
    converted = converted.split(")").join("");
    converted = converted.split(" ").join("");
    converted = converted.split("-").join("");
    if(converted.startsWith("+")) {
      converted = converted.substring(3);
    }
    return converted;
  }
}