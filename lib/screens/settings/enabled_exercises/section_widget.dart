import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/screens/settings/enabled_exercises/box_drawing_character_widgets/up_and_right_box_drawing_character_widget.dart';
import 'package:grammatika/screens/settings/enabled_exercises/box_drawing_character_widgets/vertical_and_right_box_drawing_character_widget.dart';
import 'package:grammatika/screens/settings/enabled_exercises/box_drawing_character_widgets/vertical_box_drawing_character_widget.dart';
import 'package:grammatika/screens/settings/enabled_exercises/exercise_cell.dart';
import 'package:grammatika/screens/settings/enabled_exercises/exercise_section.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';

class SectionWidget extends StatefulWidget {
  const SectionWidget({
    super.key,
    required this.section,
    this.depth = 0,
    required this.isLastSubSection,
    this.sectionHasCheckBoxBuilder,
  });
  final ExerciseSection section;
  final int depth;
  final bool isLastSubSection;
  final bool Function(int)? sectionHasCheckBoxBuilder;

  @override
  State<SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  final ExpansionTileController controller = ExpansionTileController();
  bool isFirstBuild = true;
  late bool? subSectionsEnabled = widget.section.subSectionsEnabled();

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
      subSectionsEnabled = widget.section.subSectionsEnabled();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subSections = widget.section.subSections;
    final exercises = widget.section.exercises;
    final sectionHasCheckBoxBuilder = widget.sectionHasCheckBoxBuilder;
    final expansionTile = ExpansionTile(
      trailing: sectionHasCheckBoxBuilder != null &&
              sectionHasCheckBoxBuilder.call(widget.depth)
          ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Checkbox(
                  value: subSectionsEnabled,
                  tristate: true,
                  onChanged: (value) {
                    final enabledExercisesService =
                        GetIt.instance.get<EnabledExercisesService>();
                    final exerciseIds = widget.section
                        .flattenExercises()
                        .map(
                          (e) => e.$1,
                        )
                        .toList();
                    setState(() {
                      final newValue = value ?? false;
                      subSectionsEnabled = newValue;
                      newValue
                          ? enabledExercisesService
                              .removeDisabledExercises(exerciseIds)
                          : enabledExercisesService
                              .addDisabledExercises(exerciseIds);
                    });
                  }),
            )
          : const SizedBox.shrink(),
      onExpansionChanged: (_) => setState(() {}),
      controller: controller,
      collapsedShape: LinearBorder.none,
      shape: LinearBorder.none,
      minTileHeight: 0,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      tilePadding: EdgeInsets.zero,
      title: Container(
        height: 36.0,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        child: Row(
          children: [
            ...List.generate(
              widget.depth,
              (index) => Padding(
                padding: const EdgeInsets.only(left: 16),
                child: index == widget.depth - 1
                    ? widget.isLastSubSection &&
                            (isFirstBuild || !controller.isExpanded)
                        ? const UpAndRightBoxDrawingCharacterWidget()
                        : const VerticalAndRightBoxDrawingCharacterWidget()
                    : const VerticalBoxDrawingCharacterWidget(),
              ),
            ),
            const SizedBox(width: 4.0),
            Text(
              widget.section.title,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.0),
            ),
            Icon(
              isFirstBuild || !controller.isExpanded
                  ? Icons.arrow_drop_down
                  : Icons.arrow_drop_up,
            ),
          ],
        ),
      ),
      children: (subSections != null)
          ? subSections
              .map((e) => SectionWidget(
                    sectionHasCheckBoxBuilder: (depth) => true,
                    section: e,
                    depth: widget.depth + 1,
                    isLastSubSection:
                        subSections.indexOf(e) == subSections.length - 1,
                  ))
              .toList()
          : exercises!.map(
              (exercise) {
                return ExerciseCell(
                    exercise: exercise,
                    depth: widget.depth + 1,
                    isLastExerciseInList:
                        exercises.indexOf(exercise) == exercises.length - 1);
              },
            ).toList(),
    );
    isFirstBuild = false;
    return expansionTile;
  }
}
