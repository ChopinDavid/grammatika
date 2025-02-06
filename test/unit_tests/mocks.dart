import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchu/blocs/exercise/exercise_bloc.dart';
import 'package:uchu/blocs/translation/translation_bloc.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/services/navigation_service.dart';
import 'package:uchu/services/theme_service.dart';
import 'package:uchu/services/translation_service.dart';
import 'package:uchu/utilities/db_helper.dart';
import 'package:uchu/utilities/exercise_helper.dart';
import 'package:uchu/utilities/explanation_helper.dart';
import 'package:uchu/utilities/url_helper.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockDbHelper extends Mock implements DbHelper {}

class MockDatabase extends Mock implements Database {}

class MockNoun extends Mock implements Noun {
  @override
  Map<String, dynamic> toJson() {
    return Noun.testValue().toJson();
  }
}

class MockExerciseBloc extends MockBloc<ExerciseEvent, ExerciseState>
    implements ExerciseBloc {}

class MockExplanationHelper extends Mock implements ExplanationHelper {}

class MockRandom extends Mock implements Random {}

class MockTextStyle extends Mock implements TextStyle {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '';
  }
}

class MockExerciseHelper extends Mock implements ExerciseHelper {}

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class MockUrlHelper extends Mock implements UrlHelper {}

class MockTranslationService extends Mock implements TranslationService {}

class MockClient extends Mock implements Client {}

class MockTranslationBloc extends MockBloc<TranslationEvent, TranslationState>
    implements TranslationBloc {}

class MockNavigatorState extends Mock implements NavigatorState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class MockNavigationService extends Mock implements NavigationService {}

class MockBuildContext extends Mock implements BuildContext {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockSharedPreferencesService extends Mock implements ThemeService {}
