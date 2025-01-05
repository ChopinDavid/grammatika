import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/blocs/translation/translation_bloc.dart';
import 'package:uchu/widgets/translation_widget.dart';

import '../mocks.dart';

main() {
  late TranslationBloc mockTranslationBloc;
  late NavigatorState mockNavigatorState;

  setUp(() {
    mockTranslationBloc = MockTranslationBloc();
    mockNavigatorState = MockNavigatorState();

    whenListen(
        mockTranslationBloc,
        Stream.fromIterable([
          const TranslationLoading(),
          const TranslationLoaded(translation: 'translation'),
        ]),
        initialState: const TranslationInitial());
  });

  group('when state is TranslationLoaded', () {
    testWidgets('displays translation', (tester) async {
      const expectedTranslation =
          'The quick brown fox jumps over the lazy dog.';
      whenListen(
          mockTranslationBloc,
          Stream.fromIterable(
              [const TranslationLoaded(translation: expectedTranslation)]),
          initialState: const TranslationInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockTranslationBloc,
            child: TranslationWidget(
              mockNavigatorState: mockNavigatorState,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(expectedTranslation), findsOneWidget);
    });

    testWidgets(
      'there is a close button and tapping it invokes NavigatorState.pop',
      (tester) async {
        whenListen(
            mockTranslationBloc,
            Stream.fromIterable(
                [const TranslationLoaded(translation: 'translation')]),
            initialState: const TranslationInitial());

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: mockTranslationBloc,
              child: TranslationWidget(
                mockNavigatorState: mockNavigatorState,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final closeIconFinder = find.byIcon(Icons.close);
        expect(closeIconFinder, findsOneWidget);
        await tester.tap(closeIconFinder);
        verify(() => mockNavigatorState.pop()).called(1);
      },
    );
  });

  group('when state is TranslationError', () {
    testWidgets('displays error message', (tester) async {
      whenListen(
          mockTranslationBloc,
          Stream.fromIterable(
              [const TranslationError(errorString: 'something went wrong!')]),
          initialState: const TranslationInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockTranslationBloc,
            child: TranslationWidget(
              mockNavigatorState: mockNavigatorState,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('There was an issue loading translation...'),
          findsOneWidget);
    });

    testWidgets(
      'there is a close button and tapping it invokes NavigatorState.pop',
      (tester) async {
        whenListen(
            mockTranslationBloc,
            Stream.fromIterable(
                [const TranslationError(errorString: 'something went wrong!')]),
            initialState: const TranslationInitial());

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: mockTranslationBloc,
              child: TranslationWidget(
                mockNavigatorState: mockNavigatorState,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final closeIconFinder = find.byIcon(Icons.close);
        expect(closeIconFinder, findsOneWidget);
        await tester.tap(closeIconFinder);
        verify(() => mockNavigatorState.pop()).called(1);
      },
    );
  });

  group('when state is TranslationInitial', () {
    testWidgets('displays error message', (tester) async {
      whenListen(mockTranslationBloc, Stream.fromIterable(<TranslationState>[]),
          initialState: const TranslationInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockTranslationBloc,
            child: TranslationWidget(
              mockNavigatorState: mockNavigatorState,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.idle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
      'there is a close button and tapping it invokes NavigatorState.pop',
      (tester) async {
        whenListen(
            mockTranslationBloc, Stream.fromIterable(<TranslationState>[]),
            initialState: const TranslationInitial());

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: mockTranslationBloc,
              child: TranslationWidget(
                mockNavigatorState: mockNavigatorState,
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.idle();

        final closeIconFinder = find.byIcon(Icons.close);
        expect(closeIconFinder, findsOneWidget);
        await tester.tap(closeIconFinder);
        verify(() => mockNavigatorState.pop()).called(1);
      },
    );
  });

  group('when state is TranslationLoading', () {
    testWidgets('displays error message', (tester) async {
      whenListen(
          mockTranslationBloc,
          Stream.fromIterable(
            [
              const TranslationLoading(),
            ],
          ),
          initialState: const TranslationInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockTranslationBloc,
            child: TranslationWidget(
              mockNavigatorState: mockNavigatorState,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.idle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
      'there is a close button and tapping it invokes NavigatorState.pop',
      (tester) async {
        whenListen(
            mockTranslationBloc,
            Stream.fromIterable(
              [
                const TranslationLoading(),
              ],
            ),
            initialState: const TranslationInitial());

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: mockTranslationBloc,
              child: TranslationWidget(
                mockNavigatorState: mockNavigatorState,
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.idle();

        final closeIconFinder = find.byIcon(Icons.close);
        expect(closeIconFinder, findsOneWidget);
        await tester.tap(closeIconFinder);
        verify(() => mockNavigatorState.pop()).called(1);
      },
    );
  });
}
