import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grammatika/services/translation_service.dart';

import '../mocks.dart';

main() {
  late Client mockClient;
  late TranslationService testObject;

  setUp(() {
    mockClient = MockClient();
    testObject = TranslationService(client: mockClient);
  });

  group(
    'getSentenceFrom',
    () {
      const expectedTatoebaKey = 1;
      const expectedTranslation = 'translation';
      const goodResponseBody =
          '{"translations":[[{"lang":"eng","text":"$expectedTranslation"}]]}';
      const noEngTranslationResponseBody =
          '{"translations":[[{"lang":"ger","text":"Übersetzung"}]]}';

      test(
        'throws HttpException if tatoeba response is < 200',
        () async {
          when(() => mockClient.get(Uri.parse(
                  'https://tatoeba.org/en/api_v0/sentence/$expectedTatoebaKey')))
              .thenAnswer(
            (_) async => Response('error', 199),
          );

          expect(
            () async => await testObject.getSentenceFrom(tatoebaKey: 1),
            throwsA(isA<HttpException>()),
          );
        },
      );

      test(
        'throws HttpException if tatoeba response is >299',
        () async {
          when(() => mockClient.get(Uri.parse(
                  'https://tatoeba.org/en/api_v0/sentence/$expectedTatoebaKey')))
              .thenAnswer(
            (_) async => Response('error', 300),
          );

          expect(
            () async => await testObject.getSentenceFrom(tatoebaKey: 1),
            throwsA(isA<HttpException>()),
          );
        },
      );
      test(
        'does not throw an exception if tatoeba response is 200 and there is an english translation',
        () async {
          when(() => mockClient.get(Uri.parse(
                  'https://tatoeba.org/en/api_v0/sentence/$expectedTatoebaKey')))
              .thenAnswer(
            (_) async => Response(goodResponseBody, 200),
          );

          expect(await testObject.getSentenceFrom(tatoebaKey: 1),
              expectedTranslation);

          verify(() => mockClient.get(Uri.parse(
                  'https://tatoeba.org/en/api_v0/sentence/$expectedTatoebaKey')))
              .called(1);
        },
      );

      test(
        'does throw an exception if tatoeba response is 200 but there is not an english translation',
        () async {
          when(() => mockClient.get(Uri.parse(
                  'https://tatoeba.org/en/api_v0/sentence/$expectedTatoebaKey')))
              .thenAnswer(
            (_) async => Response(noEngTranslationResponseBody, 200),
          );

          expect(
            () async => await testObject.getSentenceFrom(tatoebaKey: 1),
            throwsA(isA<Exception>()),
          );
        },
      );
    },
  );
}
