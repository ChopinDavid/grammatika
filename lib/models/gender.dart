import 'package:grammatika/models/answer.dart';

enum Gender implements Answer {
  m,
  f,
  n,
  pl,
  both;

  @override
  Map<String, dynamic> toJson() {
    return {'id': name};
  }
}
