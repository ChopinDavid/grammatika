import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:uchu/services/translation_service.dart';

part 'translation_event.dart';
part 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  TranslationBloc() : super(const TranslationInitial()) {
    on<TranslationEvent>((event, emit) async {
      if (event is TranslationFetchTranslationEvent) {
        emit(const TranslationLoading());
        try {
          final translation = await GetIt.instance
              .get<TranslationService>()
              .getSentenceFrom(tatoebaKey: event.tatoebaKey);
          emit(TranslationLoaded(translation: translation));
        } catch (e) {
          emit(TranslationError(errorString: e.toString()));
        }
      }
    });
  }
}
