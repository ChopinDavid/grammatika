part of 'exercise_bloc.dart';

@immutable
abstract class ExerciseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExerciseRetrieveExerciseEvent extends ExerciseEvent {}

class ExerciseRetrieveRandomNounEvent extends ExerciseEvent {}

class ExerciseRetrieveRandomSentenceEvent extends ExerciseEvent {}

class ExerciseSubmitAnswerEvent<T> extends ExerciseEvent {
  ExerciseSubmitAnswerEvent({
    required this.exercise,
  });

  final Exercise exercise;

  @override
  List<Object?> get props => [
        ...super.props,
        exercise,
      ];
}
