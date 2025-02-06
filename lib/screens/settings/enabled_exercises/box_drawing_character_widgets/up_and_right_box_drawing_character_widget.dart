import 'package:flutter/material.dart';

class UpAndRightBoxDrawingCharacterWidget extends StatelessWidget {
  const UpAndRightBoxDrawingCharacterWidget();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyLarge?.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: VerticalDivider(
            color: color,
            width: 1.0,
            thickness: 1.0,
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(
            width: 12,
            child: Divider(
              color: color,
              thickness: 1.0,
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}
