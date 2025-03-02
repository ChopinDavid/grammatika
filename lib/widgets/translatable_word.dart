import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/utilities/url_helper.dart';
import 'package:grammatika/widgets/dashed_border_painter.dart';

class TranslatableWord extends StatelessWidget {
  const TranslatableWord(
    this.word, {
    super.key,
    this.textStyle,
  });
  final String word;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CustomPaint(
        key: const Key('translatable-custom-paint'),
        painter: const DashedBorderPainter(color: Colors.blue),
        child: Text(
          word,
          style: textStyle,
        ),
      ),
      onTap: () {
        GetIt.instance.get<UrlHelper>().launchWiktionaryPageFor(word);
      },
    );
  }
}
