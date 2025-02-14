import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/extensions/intersperse_extensions.dart';

main() {
  group('intersperse', () {
    test('intersperse adds element between each item in the list', () {
      final list = [1, 2, 3];
      final result = list.intersperse(0).toList();
      expect(result, [1, 0, 2, 0, 3]);
    });

    test('intersperse on an empty list returns an empty list', () {
      final list = <int>[];
      final result = list.intersperse(0).toList();
      expect(result, []);
    });

    test('intersperse on a single element list returns the same list', () {
      final list = [1];
      final result = list.intersperse(0).toList();
      expect(result, [1]);
    });

    test('intersperse on a list with two elements adds one element in between',
        () {
      final list = [1, 2];
      final result = list.intersperse(0).toList();
      expect(result, [1, 0, 2]);
    });
  });
}
