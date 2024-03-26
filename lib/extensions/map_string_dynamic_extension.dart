extension MapStringDynamicExtension on Map<String, dynamic> {
  int parseIntForKey(String key) {
    final json = this[key];
    final parsedIntFromJson = json is String ? int.tryParse(json) : json;
    assert(parsedIntFromJson is int, '"$key" must be of type int or String');
    return parsedIntFromJson;
  }

  int? parseOptionalIntForKey(String key) {
    final json = this[key];
    final parsedIntFromJson = json is String ? int.tryParse(json) : json;
    assert(parsedIntFromJson is int?,
        '"$key" must be of type int or String, or must be null');
    return parsedIntFromJson;
  }

  bool parseBoolForKey(String key) {
    late final bool? boolValue;
    final value = this[key];
    if (value is bool) {
      boolValue = value;
    } else if (value is int) {
      boolValue = value == 0
          ? false
          : value == 1
              ? true
              : null;
    } else if (value is String) {
      boolValue = value == '0'
          ? false
          : value == '1'
              ? true
              : null;
    } else if (value == null) {
      boolValue = false;
    } else {
      boolValue = null;
    }

    assert(boolValue is bool,
        '"$key" must be of type bool, int (0 or 1), or String ("0" or "1")');
    return boolValue!;
  }
}
