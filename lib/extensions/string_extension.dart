extension StringExtension on String {
  // TODO(DC): This could maybe be written better? Not really an extension as much as a global function.
  static bool isNullOrEmpty(final String? string) {
    if (string == null) {
      return true;
    }
    return string.isEmpty || string.trim().isEmpty;
  }
}
