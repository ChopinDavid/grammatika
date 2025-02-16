import 'package:mocktail/mocktail.dart';
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'unit_tests/mocks.dart';

class TestUtils {
  static registerFallbackValues() {
    registerFallbackValue(Gender.m);
    registerFallbackValue(WordForm.testValue());
    registerFallbackValue(Exercise<WordForm, Sentence>(
        question: Sentence.testValue(), answers: [WordForm.testValue()]));
    registerFallbackValue(MockTextStyle());
    registerFallbackValue(const LaunchOptions());
    registerFallbackValue(MockBuildContext());
  }
}
