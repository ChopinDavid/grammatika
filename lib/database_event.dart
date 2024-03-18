part of 'database_bloc.dart';

@immutable
abstract class DatabaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DatabaseQueryEvent extends DatabaseEvent {
  DatabaseQueryEvent({required this.query});

  final String query;

  @override
  List<Object?> get props => [
        ...super.props,
        query,
      ];
}
