import 'package:mocktail/mocktail.dart';
import 'package:uchu/models/gender.dart';

class TestUtils {
  static registerFallbackValues() {
    registerFallbackValue(Gender.m);
  }
}
