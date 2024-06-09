import 'package:mocktail/mocktail.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word_form.dart';

class TestUtils {
  static registerFallbackValues() {
    registerFallbackValue(Gender.m);
    registerFallbackValue(WordForm.testValue());
  }
}
