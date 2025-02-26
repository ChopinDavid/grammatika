import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grammatika/consts.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks.dart';

main() {
  late SharedPreferences mockSharedPreferences;
  late EnabledExercisesService testObject;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    when(() => mockSharedPreferences.setStringList(any(), any()))
        .thenAnswer((_) async {
      return true;
    });
    testObject =
        EnabledExercisesService(sharedPreferences: mockSharedPreferences);
  });

  group('setEnabledExercises', () {
    test(
      'stores value in shared preferences for enabledExercisesSharedPreferencesKey',
      () {
        const expected = ['exercise1', 'exercise2'];

        testObject.setEnabledExercises(expected);

        verify(
          () => mockSharedPreferences.setStringList(
            enabledExercisesSharedPreferencesKey,
            expected,
          ),
        );
      },
    );
  });

  group('getEnabledExercises', () {
    test(
      'returns value stored in shared preferences for enabledExercisesSharedPreferencesKey',
      () {
        const expected = ['exercise1', 'exercise2'];
        when(
          () => mockSharedPreferences.getStringList(
            enabledExercisesSharedPreferencesKey,
          ),
        ).thenReturn(expected);

        final actual = testObject.getEnabledExercises();

        expect(actual, expected);
      },
    );
  });

  group(
    'getDisabledExercises',
    () {
      test(
        'returns any exerciseIds not returned by getEnabledExercises',
        () {
          final allExerciseIds = getAllExerciseIds();
          final disabledExerciseIdIndex =
              Random().nextInt(allExerciseIds.length);
          final enabledExerciseIds = List.of(allExerciseIds)
            ..removeAt(disabledExerciseIdIndex);

          when(() => mockSharedPreferences
                  .getStringList(enabledExercisesSharedPreferencesKey))
              .thenReturn(enabledExerciseIds);

          final actual = testObject.getDisabledExercises();

          expect(actual, [allExerciseIds[disabledExerciseIdIndex]]);
        },
      );
    },
  );
}
