import 'package:flutter/material.dart';

class ExplanationsWidget extends StatelessWidget {
  const ExplanationsWidget({
    super.key,
    required this.explanation,
    required this.visualExplanation,
  });
  final String? explanation;
  final String? visualExplanation;

  @override
  Widget build(BuildContext context) {
    final explanation = this.explanation;
    final visualExplanation = this.visualExplanation;

    final gradientColor = Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (explanation != null)
                Text(
                  explanation,
                  key: const Key('explanation-text'),
                ),
              if (visualExplanation != null)
                Center(
                  child: Text(
                    visualExplanation,
                    key: const Key('visual-explanation-text'),
                  ),
                ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 16.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    gradientColor,
                    gradientColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
            Container(
              height: 16.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    gradientColor.withValues(alpha: 0.0),
                    gradientColor,
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
