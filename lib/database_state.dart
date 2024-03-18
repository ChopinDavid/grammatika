part of 'database_bloc.dart';

@immutable
abstract class DatabaseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DatabaseInitial extends DatabaseState {}

class DatabaseRetrievingRandomNounState extends DatabaseState {}

class DatabaseRandomNounRetrievedState extends DatabaseState {
  DatabaseRandomNounRetrievedState({
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

class DatabaseErrorState extends DatabaseState {
  DatabaseErrorState({
    required this.errorString,
  });
  final String errorString;

  @override
  List<Object?> get props => [...super.props, errorString];
}
