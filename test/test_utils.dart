import 'package:mocktail/mocktail.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';

import 'unit_tests/mocks.dart';

class TestUtils {
  static registerFallbackValues() {
    registerFallbackValue(Gender.m);
    registerFallbackValue(WordForm.testValue());
    registerFallbackValue(Exercise<WordForm, Sentence>(
        question: Sentence.testValue(), answers: [WordForm.testValue()]));
    registerFallbackValue(MockTextStyle());
  }
}
