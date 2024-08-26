import 'package:uchu/models/gender.dart';

extension GenderExtension on Gender {
  String get displayString {
    switch (this) {
      case Gender.m:
        return 'Masculine';
      case Gender.f:
        return 'Feminine';
      case Gender.n:
        return 'Neuter';
      case Gender.pl:
        return 'Plural';
      case Gender.both:
        return 'Both';
    }
  }

  static Gender? fromString(String? string) {
    switch (string) {
      case null:
        return null;
      case 'm':
        return Gender.m;
      case 'f':
        return Gender.f;
      case 'n':
        return Gender.n;
      case 'pl':
        return Gender.pl;
      case 'both':
        return Gender.both;
      default:
        throw Exception('String id did not match any Gender.');
    }
  }
}
