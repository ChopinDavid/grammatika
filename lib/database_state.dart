part of 'database_bloc.dart';

@immutable
abstract class DatabaseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DatabaseInitial extends DatabaseState {}

class DatabaseQueryingState extends DatabaseState {
  DatabaseQueryingState({required this.query});
  final String query;
  @override
  List<Object?> get props => [...super.props, query];
}

class DatabaseQueryCompleteState extends DatabaseState {
  DatabaseQueryCompleteState({
    required this.queryResult,
  });
  final List<Map<String, Object?>> queryResult;

  @override
  List<Object?> get props => [...super.props, queryResult];
}

class DatabaseQueryErrorState extends DatabaseState {
  DatabaseQueryErrorState({
    required this.errorString,
  });
  final String errorString;

  @override
  List<Object?> get props => [...super.props, errorString];
}
