import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/utilities/db_helper.dart';
import 'package:uchu/utilities/explanation_helper.dart';

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
