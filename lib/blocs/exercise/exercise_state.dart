part of 'exercise_bloc.dart';

@immutable
abstract class ExerciseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseRetrievingExerciseState extends ExerciseState {}

class ExerciseExerciseRetrievedState extends ExerciseState {}

class ExerciseErrorState extends ExerciseState {
  ExerciseErrorState({
    required this.errorString,
  });
  final String errorString;

  @override
  List<Object?> get props => [...super.props, errorString];
}

class ExerciseAnswerSelectedState<T> extends ExerciseState {}
