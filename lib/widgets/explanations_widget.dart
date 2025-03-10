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

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (explanation != null)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Explanation: ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    TextSpan(
                        text: explanation,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
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
      ],
    );
  }
}
