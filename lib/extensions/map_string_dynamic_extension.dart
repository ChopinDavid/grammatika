extension MapStringDynamicExtension on Map<String, dynamic> {
  int parseIntFromStringOrInt(String key) {
    final json = this[key];
    final parsedIntFromJson = json is String ? int.tryParse(json) : json;
    assert(parsedIntFromJson is int, '"$key" must be of type int or String');
    return parsedIntFromJson;
  }

  int? parseOptionalIntFromStringOrInt(String key) {
    final json = this[key];
    final parsedIntFromJson = json is String ? int.tryParse(json) : json;
    assert(parsedIntFromJson is int?,
        '"$key" must be of type int or String, or must be null');
    return parsedIntFromJson;
  }
}
