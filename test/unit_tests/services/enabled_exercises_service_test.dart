import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/services/enabled_exercises_service.dart';

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

  group(
    'getDisabledExercises',
    () {
      test(
        'returns value stored in shared preferences for disabledExercisesSharedPreferencesKey',
        () {
          const expected = ['exercise1', 'exercise2'];
          when(() => mockSharedPreferences.getStringList(
              disabledExercisesSharedPreferencesKey)).thenReturn(expected);

          final actual = testObject.getDisabledExercises();

          expect(actual, expected);
        },
      );
    },
  );

  group(
    'getExerciseEnabled',
    () {
      test(
        'returns true when passed exerciseIdentifier is not included in value stored in shared preferences for disabledExercisesSharedPreferencesKey',
        () {
          when(() => mockSharedPreferences
                  .getStringList(disabledExercisesSharedPreferencesKey))
              .thenReturn(['exercise1', 'exercise2']);

          final actual = testObject.getExerciseEnabled('exercise3');

          expect(actual, isTrue);
        },
      );

      test(
        'returns true when passed exerciseIdentifier is not included in value stored in shared preferences for disabledExercisesSharedPreferencesKey',
        () {
          const expectedExercises = ['exercise1', 'exercise2'];
          when(() => mockSharedPreferences
                  .getStringList(disabledExercisesSharedPreferencesKey))
              .thenReturn(expectedExercises);

          final actual = testObject.getExerciseEnabled(expectedExercises.last);

          expect(actual, isFalse);
        },
      );
    },
  );

  group('addDisabledExercises', () {
    test(
      'adds passed exerciseIds to value stored in shared preferences for disabledExercisesSharedPreferencesKey',
      () {
        var existingDisabledExerciseIds = ['exercise1', 'exercise2'];
        var newDisabledExerciseIds = ['exercise3', 'exercise4'];
        when(() => mockSharedPreferences
                .getStringList(disabledExercisesSharedPreferencesKey))
            .thenReturn(existingDisabledExerciseIds);

        testObject.addDisabledExercises(newDisabledExerciseIds);

        verify(() => mockSharedPreferences.setStringList(
            disabledExercisesSharedPreferencesKey,
            <String>{...existingDisabledExerciseIds, ...newDisabledExerciseIds}
                .toList()));
      },
    );

    test('notifies listeners', () {
      var existingDisabledExerciseIds = ['exercise1', 'exercise2'];
      var newDisabledExerciseIds = ['exercise3', 'exercise4'];
      when(() => mockSharedPreferences
              .getStringList(disabledExercisesSharedPreferencesKey))
          .thenReturn(existingDisabledExerciseIds);

      int listenerNotifyCount = 0;
      testObject.addListener(() {
        listenerNotifyCount++;
      });

      testObject.addDisabledExercises(newDisabledExerciseIds);

      expect(listenerNotifyCount, 1);
    });
  });

  group('removeDisabledExercises', () {
    test(
        'removes passed exerciseIds from value stored in shared preferences for disabledExercisesSharedPreferencesKey',
        () {
      var existingDisabledExerciseIds = ['exercise1', 'exercise2', 'exercise3'];
      var exerciseIdsToRemove = ['exercise1'];
      when(() => mockSharedPreferences
              .getStringList(disabledExercisesSharedPreferencesKey))
          .thenReturn(existingDisabledExerciseIds);

      testObject.removeDisabledExercises(exerciseIdsToRemove);

      verify(
        () => mockSharedPreferences.setStringList(
          disabledExercisesSharedPreferencesKey,
          existingDisabledExerciseIds
            ..removeWhere(
              (element) => element == exerciseIdsToRemove.single,
            ),
        ),
      );
    });

    test('notifies listeners', () {
      var existingDisabledExerciseIds = ['exercise1', 'exercise2', 'exercise3'];
      var exerciseIdsToRemove = ['exercise1'];
      when(() => mockSharedPreferences
              .getStringList(disabledExercisesSharedPreferencesKey))
          .thenReturn(existingDisabledExerciseIds);

      int listenerNotifyCount = 0;
      testObject.addListener(() {
        listenerNotifyCount++;
      });

      testObject.removeDisabledExercises(exerciseIdsToRemove);

      expect(listenerNotifyCount, 1);
    });
  });

  group('toggleExerciseEnabled', () {
    test(
        'sets list of passed exerciseIdentifier when value stored in shared preferences for disabledExercisesSharedPreferencesKey is null',
        () {
      const exerciseIdToToggle = 'exercise1';
      when(() => mockSharedPreferences.getStringList(
          disabledExercisesSharedPreferencesKey)).thenReturn(null);

      testObject.toggleExerciseEnabled(exerciseIdToToggle);

      verify(
        () => mockSharedPreferences.setStringList(
            disabledExercisesSharedPreferencesKey, [exerciseIdToToggle]),
      );
    });

    test(
        'removes exerciseIdentifier when it already exists in value stored in shared preferences for disabledExercisesSharedPreferencesKey',
        () {
      const exerciseIdToToggle = 'exercise1';
      var existingDisabledExerciseIds = [
        exerciseIdToToggle,
        'exercise2',
        'exercise3'
      ];
      when(() => mockSharedPreferences
              .getStringList(disabledExercisesSharedPreferencesKey))
          .thenReturn(existingDisabledExerciseIds);

      testObject.toggleExerciseEnabled(exerciseIdToToggle);

      verify(
        () => mockSharedPreferences.setStringList(
          disabledExercisesSharedPreferencesKey,
          existingDisabledExerciseIds
            ..removeWhere(
              (element) => element == exerciseIdToToggle,
            ),
        ),
      );
    });

    test(
        'adds exerciseIdentifier when it does not already exist in value stored in shared preferences for disabledExercisesSharedPreferencesKey',
        () {
      const exerciseIdToToggle = 'exercise4';
      var existingDisabledExerciseIds = ['exercise1', 'exercise2', 'exercise3'];
      when(() => mockSharedPreferences
              .getStringList(disabledExercisesSharedPreferencesKey))
          .thenReturn(existingDisabledExerciseIds);

      testObject.toggleExerciseEnabled(exerciseIdToToggle);

      verify(
        () => mockSharedPreferences.setStringList(
          disabledExercisesSharedPreferencesKey,
          existingDisabledExerciseIds
            ..add(
              exerciseIdToToggle,
            ),
        ),
      );
    });

    test('notifies listeners', () {
      const exerciseIdToToggle = 'exercise1';
      var existingDisabledExerciseIds = [
        exerciseIdToToggle,
        'exercise2',
        'exercise3'
      ];
      when(() => mockSharedPreferences
              .getStringList(disabledExercisesSharedPreferencesKey))
          .thenReturn(existingDisabledExerciseIds);

      int listenerNotifyCount = 0;
      testObject.addListener(() {
        listenerNotifyCount++;
      });

      testObject.toggleExerciseEnabled(exerciseIdToToggle);

      expect(listenerNotifyCount, 1);
    });
  });
}
