import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:grammatika/blocs/exercise/exercise_bloc.dart';
import 'package:grammatika/blocs/translation/translation_bloc.dart';
import 'package:grammatika/models/noun.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';
import 'package:grammatika/services/navigation_service.dart';
import 'package:grammatika/services/statistics_service.dart';
import 'package:grammatika/services/theme_service.dart';
import 'package:grammatika/services/translation_service.dart';
import 'package:grammatika/utilities/db_helper.dart';
import 'package:grammatika/utilities/exercise_helper.dart';
import 'package:grammatika/utilities/explanation_helper.dart';
import 'package:grammatika/utilities/url_helper.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
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
  MockTextStyle() {
    when(
      () => copyWith(
        leadingDistribution: any(named: 'leadingDistribution'),
        fontSize: any(named: 'fontSize'),
        height: any(named: 'height'),
        textBaseline: any(named: 'textBaseline'),
        fontWeight: any(named: 'fontWeight'),
        color: any(named: 'color'),
        backgroundColor: any(named: 'backgroundColor'),
        background: any(named: 'background'),
        debugLabel: any(named: 'debugLabel'),
        decoration: any(named: 'decoration'),
        decorationColor: any(named: 'decorationColor'),
        decorationStyle: any(named: 'decorationStyle'),
        decorationThickness: any(named: 'decorationThickness'),
        fontFamily: any(named: 'fontFamily'),
        fontFamilyFallback: any(named: 'fontFamilyFallback'),
        fontFeatures: any(named: 'fontFeatures'),
        fontStyle: any(named: 'fontStyle'),
        fontVariations: any(named: 'fontVariations'),
        foreground: any(named: 'foreground'),
        inherit: any(named: 'inherit'),
        letterSpacing: any(named: 'letterSpacing'),
        locale: any(named: 'locale'),
        overflow: any(named: 'overflow'),
        package: any(named: 'package'),
        shadows: any(named: 'shadows'),
        wordSpacing: any(named: 'wordSpacing'),
      ),
    ).thenReturn(this);
  }
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

class MockThemeService extends Mock implements ThemeService {}

class MockEnabledExercisesService extends Mock
    implements EnabledExercisesService {
  MockEnabledExercisesService() {
    when(() => getDisabledExercises()).thenReturn([]);
    when(() => getEnabledExercises()).thenReturn([]);
  }
}

class MockStatisticsService extends Mock implements StatisticsService {}
