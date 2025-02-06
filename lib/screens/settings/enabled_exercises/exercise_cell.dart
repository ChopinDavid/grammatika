import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/screens/settings/enabled_exercises/box_drawing_character_widgets/up_and_right_box_drawing_character_widget.dart';
import 'package:uchu/screens/settings/enabled_exercises/box_drawing_character_widgets/vertical_and_right_box_drawing_character_widget.dart';
import 'package:uchu/screens/settings/enabled_exercises/box_drawing_character_widgets/vertical_box_drawing_character_widget.dart';
import 'package:uchu/services/enabled_exercises_service.dart';

class ExerciseCell extends StatefulWidget {
  const ExerciseCell({
    super.key,
    required this.exercise,
    required this.depth,
    required this.isLastExerciseInList,
  });
  final (String, String) exercise;
  final int depth;
  final bool isLastExerciseInList;

  @override
  State<ExerciseCell> createState() => _ExerciseCellState();
}

class _ExerciseCellState extends State<ExerciseCell> {
  late bool isEnabled = GetIt.instance
      .get<EnabledExercisesService>()
      .getExerciseEnabled(widget.exercise.$1);
  @override
  void initState() {
    super.initState();
    GetIt.instance
        .get<EnabledExercisesService>()
        .addListener(_enabledExerciseServiceListener);
  }

  @override
  void dispose() {
    super.dispose();
    GetIt.instance
        .get<EnabledExercisesService>()
        .removeListener(_enabledExerciseServiceListener);
  }

  void _enabledExerciseServiceListener() {
    setState(() {
      isEnabled = GetIt.instance
          .get<EnabledExercisesService>()
          .getExerciseEnabled(widget.exercise.$1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...List.generate(
            widget.depth,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16),
                child: index == widget.depth - 1
                    ? widget.isLastExerciseInList
                        ? const UpAndRightBoxDrawingCharacterWidget()
                        : const VerticalAndRightBoxDrawingCharacterWidget()
                    : const VerticalBoxDrawingCharacterWidget(),
              );
            },
          ),
          const SizedBox(width: 4.0),
          Expanded(
            child: InkWell(
              child: Row(
                children: [
                  Text(widget.exercise.$2),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: IgnorePointer(
                      child: SizedBox.square(
                        dimension: Checkbox.width,
                        child: Checkbox(
                          value: isEnabled,
                          onChanged: (_) {
                            setState(() {
                              GetIt.instance
                                  .get<EnabledExercisesService>()
                                  .toggleExerciseEnabled(widget.exercise.$1);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  GetIt.instance
                      .get<EnabledExercisesService>()
                      .toggleExerciseEnabled(widget.exercise.$1);
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
