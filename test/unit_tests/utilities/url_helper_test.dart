import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/utilities/url_helper.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../test_utils.dart';
import '../mocks.dart';

main() {
  late UrlHelper testObject;
  late UrlLauncherPlatform mockUrlLauncher;

  setUpAll(TestUtils.registerFallbackValues);

  setUp(() {
    testObject = const UrlHelper();

    mockUrlLauncher = MockUrlLauncher();
    when(() => mockUrlLauncher.launchUrl(any(), any()))
        .thenAnswer((_) async => true);

    UrlLauncherPlatform.instance = mockUrlLauncher;
  });

  group('launchWiktionaryPageFor', () {
    test('passed String is lowercased when constructing url', () async {
      const word = 'Яблоко';
      await testObject.launchWiktionaryPageFor(word);

      verify(() => mockUrlLauncher.launchUrl(
          'https://en.wiktionary.org/wiki/${Uri.encodeFull(word.toLowerCase())}#Russian',
          any()));
    });

    test('passed String has punctuation removed when constructing url',
        () async {
      const word = 'Яблоко,.?!';
      await testObject.launchWiktionaryPageFor(word);

      verify(() => mockUrlLauncher.launchUrl(
          'https://en.wiktionary.org/wiki/${Uri.encodeFull('яблоко')}#Russian',
          any()));
    });
  });

  test(
    'launchUrl creates and launches url created from passed String',
    () async {
      const expectedUrl = 'https://www.google.com';
      await testObject.launchUrl(expectedUrl);

      verify(() => mockUrlLauncher.launchUrl(expectedUrl, any()));
    },
  );
}
