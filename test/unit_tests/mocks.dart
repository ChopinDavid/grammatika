import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/noun.dart';

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
