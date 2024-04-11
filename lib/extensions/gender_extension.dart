import 'package:uchu/models/gender.dart';

extension GenderExtension on Gender {
  String? get displayString {
    switch (this) {
      case Gender.m:
        return 'Masculine';
      case Gender.f:
        return 'Feminine';
      case Gender.n:
        return 'Neuter';
      default:
        return null;
    }
  }
}
