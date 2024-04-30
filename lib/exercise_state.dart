part of 'exercise_bloc.dart';

@immutable
abstract class ExerciseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseRetrievingRandomNounState extends ExerciseState {}

class ExerciseRandomNounRetrievedState extends ExerciseState {
  ExerciseRandomNounRetrievedState({
    required this.noun,
    required this.word,
  });
  final Noun noun;
  final Word word;

  @override
  List<Object?> get props => [
        ...super.props,
        noun,
        word,
      ];
}

class ExerciseRandomSentenceRetrievedState extends ExerciseState {
  ExerciseRandomSentenceRetrievedState({
    required this.sentence,
    required this.answers,
  });
  final Sentence sentence;
  final List<String> answers;

  @override
  List<Object?> get props => [
        ...super.props,
        sentence,
        answers,
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

class ExerciseExerciseGradedState<T> extends ExerciseState {
  ExerciseExerciseGradedState({
    required this.answer,
  });
  final Answer answer;

  @override
  List<Object?> get props => [
        ...super.props,
        answer,
      ];
}
