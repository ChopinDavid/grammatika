part of 'database_bloc.dart';

@immutable
abstract class DatabaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DatabaseRetrieveExerciseEvent extends DatabaseEvent {}

class DatabaseRetrieveRandomNounEvent extends DatabaseEvent {}
