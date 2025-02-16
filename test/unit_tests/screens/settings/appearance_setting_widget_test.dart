import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grammatika/screens/settings/appearance_setting_widget.dart';

main() {
  group('onSelected', () {
    testWidgets(
      'is invoked when InkWell is tapped',
      (widgetTester) async {
        int onSelectedCallCount = 0;
        await widgetTester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppearanceSettingWidget(
                  isSelected: true,
                  title: 'some title',
                  icon: Icons.catching_pokemon,
                  onSelected: () => onSelectedCallCount++),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.byType(InkWell));
        await widgetTester.pumpAndSettle();

        expect(onSelectedCallCount, 1);
      },
    );
  });

  group(
    'title',
    () {
      testWidgets(
        'is displayed',
        (widgetTester) async {
          const expectedTitle = 'some title';
          await widgetTester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: AppearanceSettingWidget(
                  isSelected: true,
                  title: expectedTitle,
                  icon: Icons.catching_pokemon,
                  onSelected: () {},
                ),
              ),
            ),
          );
          await widgetTester.pumpAndSettle();

          expect(find.text(expectedTitle), findsOneWidget);
        },
      );
    },
  );

  group(
    'icon',
    () {
      testWidgets(
        'is shown',
        (widgetTester) async {
          const expectedIcon = Icons.catching_pokemon;
          await widgetTester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: AppearanceSettingWidget(
                  isSelected: true,
                  title: 'some title',
                  icon: expectedIcon,
                  onSelected: () {},
                ),
              ),
            ),
          );
          await widgetTester.pumpAndSettle();

          expect(find.byIcon(expectedIcon), findsOneWidget);
        },
      );
    },
  );

  group('isSelected', () {
    testWidgets(
      'modifies appearance correctly when true',
      (widgetTester) async {
        await widgetTester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppearanceSettingWidget(
                isSelected: true,
                title: 'some title',
                icon: Icons.catching_pokemon,
                onSelected: () {},
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        final container = widgetTester.widget<Container>(
          find.byType(Container),
        );
        final border = (container.decoration as BoxDecoration).border as Border;
        expect(border.top.color, Colors.blueAccent);
        expect(border.bottom.color, Colors.blueAccent);
        expect(border.left.color, Colors.blueAccent);
        expect(border.right.color, Colors.blueAccent);

        final icon =
            widgetTester.widget<Icon>(find.byKey(const Key('selected_icon')));
        expect(icon.icon, Icons.check_circle);
        expect(icon.color, Colors.blueAccent);
      },
    );

    testWidgets(
      'modifies appearance correctly when false',
      (widgetTester) async {
        await widgetTester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppearanceSettingWidget(
                isSelected: false,
                title: 'some title',
                icon: Icons.catching_pokemon,
                onSelected: () {},
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        final container = widgetTester.widget<Container>(
          find.byType(Container),
        );
        final border = (container.decoration as BoxDecoration).border as Border;
        expect(border.top.color, Colors.grey);
        expect(border.bottom.color, Colors.grey);
        expect(border.left.color, Colors.grey);
        expect(border.right.color, Colors.grey);

        final icon =
            widgetTester.widget<Icon>(find.byKey(const Key('selected_icon')));
        expect(icon.icon, Icons.circle_outlined);
        expect(icon.color, Colors.grey);
      },
    );
  });
}
