import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/blocs/translation/translation_bloc.dart';

class TranslationWidget extends StatelessWidget {
  const TranslationWidget({
    super.key,
    @visibleForTesting this.mockNavigatorState,
  });

  final NavigatorState? mockNavigatorState;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed:
                        (mockNavigatorState ?? Navigator.of(context)).pop,
                    icon: const Icon(Icons.close))
              ],
            ),
            BlocBuilder<TranslationBloc, TranslationState>(
              builder: (context, state) {
                if (state is TranslationLoaded) {
                  return Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      bottom: 24.0,
                    ),
                    child: Text(state.translation),
                  ));
                }

                if (state is TranslationError) {
                  return const Text(
                      'There was an issue loading translation...');
                }

                return const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: CircularProgressIndicator()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
