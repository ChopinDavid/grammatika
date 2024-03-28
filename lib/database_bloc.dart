import "dart:math";

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseBloc() : super(DatabaseInitial()) {
    on<DatabaseEvent>((event, emit) async {
      if (event is DatabaseRetrieveExerciseEvent) {
        final random = Random();
        final exerciseType =
            Exercise.values[random.nextInt(Exercise.values.length)];
        if (exerciseType == Exercise.determineNounGender) {
          add(DatabaseRetrieveRandomNounEvent());
        }
      }

      if (event is DatabaseRetrieveRandomNounEvent) {
        emit(DatabaseRetrievingRandomNounState());

        try {
          final db = await GetIt.instance.get<DbHelper>().getDatabase();

          final noun = Noun.fromJson(
            ((await db.rawQuery(
                        "SELECT * FROM nouns ORDER BY RANDOM() LIMIT 1;"))
                    as List<Map<String, dynamic>>)
                .single,
          );

          final word = await noun.word;

          emit(
            DatabaseRandomNounRetrievedState(
              noun: noun,
              word: word,
            ),
          );
        } catch (e) {
          emit(
            DatabaseErrorState(errorString: 'Unable to parse noun from JSON'),
          );
        }
      }
    });
  }
}
