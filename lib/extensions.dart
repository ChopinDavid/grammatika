extension StringExtensions on String {
  // TODO(DC): This could maybe be written better? Not really an extension as much as a global function.
  // TODO(DC): Write tests for this
  // TODO(DC): Move this into its own file in the extensions directory
  static bool isNullOrEmpty(final String? string) {
    if (string == null) {
      return true;
    }
    return string.isEmpty || string.trim().isEmpty;
  }
}
