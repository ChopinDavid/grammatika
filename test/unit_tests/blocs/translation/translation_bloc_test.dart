import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/blocs/translation/translation_bloc.dart';
import 'package:uchu/services/translation_service.dart';

import '../../mocks.dart';

main() {
  late TranslationService mockTranslationService;
  late TranslationBloc testObject;
  const expectedTatoebaKey = 123;
  const expectedTranslation = 'the quick brown fox jumps over the lazy dog';
  const expectedErrorMessage = 'something went wrong!';

  setUp(() async {
    await GetIt.instance.reset();
    mockTranslationService = MockTranslationService();
    GetIt.instance
        .registerSingleton<TranslationService>(mockTranslationService);

    testObject = TranslationBloc();
  });

  blocTest(
      'emits TranslationLoading and TranslationLoaded when TranslationService.getSentenceFrom does not throw',
      setUp: () {
        when(() => mockTranslationService.getSentenceFrom(
                tatoebaKey: expectedTatoebaKey))
            .thenAnswer((_) async => expectedTranslation);
      },
      build: () => testObject,
      act: (bloc) => bloc.add(
            const TranslationFetchTranslationEvent(
              tatoebaKey: expectedTatoebaKey,
            ),
          ),
      expect: () => [
            const TranslationLoading(),
            const TranslationLoaded(translation: expectedTranslation),
          ]);

  blocTest(
      'emits TranslationLoading and TranslationError when TranslationService.getSentenceFrom does throw',
      setUp: () {
        when(() => mockTranslationService.getSentenceFrom(
            tatoebaKey: expectedTatoebaKey)).thenThrow(expectedErrorMessage);
      },
      build: () => testObject,
      act: (bloc) => bloc.add(
            const TranslationFetchTranslationEvent(
              tatoebaKey: expectedTatoebaKey,
            ),
          ),
      expect: () => [
            const TranslationLoading(),
            const TranslationError(errorString: expectedErrorMessage),
          ]);
}
