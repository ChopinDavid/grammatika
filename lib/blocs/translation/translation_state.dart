part of 'translation_bloc.dart';

@immutable
abstract class TranslationState extends Equatable {
  const TranslationState();
  @override
  List<Object?> get props => [];
}

class TranslationInitial extends TranslationState {
  const TranslationInitial();
}

class TranslationLoading extends TranslationState {
  const TranslationLoading();
}

class TranslationLoaded extends TranslationState {
  const TranslationLoaded({
    required this.translation,
  });

  final String translation;

  @override
  List<Object?> get props => [
        ...super.props,
        translation,
      ];
}

class TranslationError extends TranslationState {
  const TranslationError({
    required this.errorString,
  });

  final String errorString;

  @override
  List<Object?> get props => [
        ...super.props,
        errorString,
      ];
}
