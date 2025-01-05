part of 'translation_bloc.dart';

@immutable
abstract class TranslationEvent extends Equatable {
  const TranslationEvent();

  @override
  List<Object?> get props => [];
}

class TranslationFetchTranslationEvent extends TranslationEvent {
  const TranslationFetchTranslationEvent({
    required this.tatoebaKey,
  });

  final int tatoebaKey;

  @override
  List<Object?> get props => [
        ...super.props,
        tatoebaKey,
      ];
}
