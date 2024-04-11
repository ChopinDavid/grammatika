part of 'exercise_bloc.dart';

@immutable
abstract class ExerciseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExerciseRetrieveExerciseEvent extends ExerciseEvent {}

class ExerciseRetrieveRandomNounEvent extends ExerciseEvent {}

class ExerciseSubmitAnswerEvent extends ExerciseEvent {
  ExerciseSubmitAnswerEvent({
    required this.answer,
  });

  final Answer answer;

  @override
  List<Object?> get props => [
        ...super.props,
        answer,
      ];
}
