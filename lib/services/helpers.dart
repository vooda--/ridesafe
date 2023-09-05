class Helpers {
  static String trimString(String string, int maxLength) {
    if (string.length > maxLength) {
      return '${string.substring(0, maxLength)}...';
    }
    return string;
  }
}