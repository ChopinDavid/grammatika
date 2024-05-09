part of 'exercise_bloc.dart';

@immutable
abstract class ExerciseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseRetrievingExerciseState extends ExerciseState {}

class ExerciseQuestionRetrievedState extends ExerciseState {
  ExerciseQuestionRetrievedState({
    required this.exercise,
  });
  final Exercise exercise;

  @override
  List<Object?> get props => [
        ...super.props,
        exercise,
      ];
}

class ExerciseErrorState extends ExerciseState {
  ExerciseErrorState({
    required this.errorString,
  });
  final String errorString;

  @override
  List<Object?> get props => [...super.props, errorString];
}

class ExerciseAnswerSelectedState extends ExerciseState {
  ExerciseAnswerSelectedState({
    required this.exercise,
  });

  final Exercise exercise;

  @override
  List<Object?> get props => [
        ...super.props,
        exercise,
      ];
}
