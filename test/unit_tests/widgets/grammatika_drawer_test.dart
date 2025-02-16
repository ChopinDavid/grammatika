import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/services/navigation_service.dart';
import 'package:grammatika/utilities/url_helper.dart';
import 'package:grammatika/widgets/grammatika_drawer.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_utils.dart';
import '../mocks.dart';

main() {
  late NavigationService mockNavigationService;
  late UrlHelper mockUrlHelper;

  setUpAll(TestUtils.registerFallbackValues);

  setUp(() async {
    await GetIt.instance.reset();

    mockNavigationService = MockNavigationService();
    mockUrlHelper = MockUrlHelper();

    when(() => mockNavigationService.pushSettingsPage(any())).thenAnswer(
      (invocation) async {},
    );

    when(() => mockNavigationService.pushStatisticsPage(any())).thenAnswer(
      (invocation) async {},
    );

    when(() => mockUrlHelper.launchUrl(any())).thenAnswer(
      (invocation) async => true,
    );

    GetIt.instance.registerSingleton<NavigationService>(mockNavigationService);
    GetIt.instance.registerSingleton<UrlHelper>(mockUrlHelper);
  });

  testWidgets(
    'Tapping "Settings" pushes the settings page',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: GrammatikaDrawer(),
        ),
      );

      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.text('Settings'));

      verify(() => mockNavigationService.pushSettingsPage(any())).called(1);
    },
  );

  testWidgets(
    'Tapping "Statistics" pushes the statistics page',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: GrammatikaDrawer(),
        ),
      );

      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.text('Statistics'));

      verify(() => mockNavigationService.pushStatisticsPage(any())).called(1);
    },
  );

  testWidgets(
    'Tapping "Bug Report/Feature Request" launches the Grammatika GitHub issues page',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: GrammatikaDrawer(),
        ),
      );

      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.text('Bug Report/Feature Request'));

      verify(() => mockUrlHelper.launchUrl(
          'https://github.com/ChopinDavid/grammatika/issues')).called(1);
    },
  );
}
