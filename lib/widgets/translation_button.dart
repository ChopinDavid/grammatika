import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/blocs/translation/translation_bloc.dart';
import 'package:uchu/widgets/translation_widget.dart';

class TranslationButton extends StatelessWidget {
  const TranslationButton({
    super.key,
    this.tatoebaKey,
    this.onPressed,
  })  : assert(tatoebaKey != null || onPressed != null,
            'Either tatoebaKey or onPressed must be provided'),
        assert(tatoebaKey == null || onPressed == null,
            'Only one of either tatoebaKey or onPressed can be provided');
  final int? tatoebaKey;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: IconButton(
        padding: const EdgeInsets.all(4),
        onPressed: onPressed ??
            () {
              final tatoebaKey = this.tatoebaKey;
              if (tatoebaKey == null) {
                // TODO(DC): Handle this scenario
                return;
              }

              showDialog(
                context: context,
                builder: (context) => Center(
                  child: BlocProvider<TranslationBloc>(
                    create: (context) {
                      return TranslationBloc()
                        ..add(TranslationFetchTranslationEvent(
                            tatoebaKey: tatoebaKey));
                    },
                    child: const TranslationWidget(),
                  ),
                ),
              );
            },
        icon: const Icon(
          Icons.translate,
          color: Colors.blue,
          size: 20,
        ),
      ),
    );
  }
}
