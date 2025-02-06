import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/services/enabled_exercises_service.dart';

class ExerciseSectionsWidget extends StatefulWidget {
  const ExerciseSectionsWidget({
    super.key,
    required this.sections,
  });
  final List<ExerciseSection> sections;

  @override
  State<ExerciseSectionsWidget> createState() => _ExerciseSectionsWidgetState();
}

class ExerciseSection {
  const ExerciseSection({required this.title, this.subSections, this.exercises})
      : assert(subSections == null || exercises == null,
            'ExerciseSection cannot have both subSections and exercises');
  final String title;
  final List<ExerciseSection>? subSections;
  final List<(String, String)>? exercises;

  List<(String, String)> flattenExercises() {
    final exercises = this.exercises;
    final subSections = this.subSections;
    return [
      if (exercises != null) ...exercises,
      if (subSections != null)
        ...subSections.expand((subSection) => subSection.flattenExercises())
    ];
  }

  bool? subSectionsEnabled() {
    final flattenedExercises = flattenExercises();
    final flattenedExerciseIds = flattenedExercises.map((e) => e.$1).toList();
    final disabledSubSections =
        GetIt.instance.get<EnabledExercisesService>().getDisabledExercises();
    final disabledExerciseIds = disabledSubSections
        .where((element) => flattenedExerciseIds.contains(element))
        .toList();
    return disabledExerciseIds.isEmpty
        ? true
        : disabledExerciseIds.length == flattenedExerciseIds.length
            ? false
            : null;
  }
}

class _ExerciseSectionsWidgetState extends State<ExerciseSectionsWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: widget.sections.length,
      itemBuilder: (context, index) {
        return _SectionWidget(
          sectionHasCheckBoxBuilder: (depth) => true,
          section: widget.sections[index],
          isLastSubsection: index == widget.sections.length - 1,
        );
      },
    );
  }
}

class _SectionWidget extends StatefulWidget {
  const _SectionWidget({
    required this.section,
    this.depth = 0,
    required this.isLastSubsection,
    this.sectionHasCheckBoxBuilder,
  });
  final ExerciseSection section;
  final int depth;
  final bool isLastSubsection;
  final bool Function(int)? sectionHasCheckBoxBuilder;

  @override
  State<_SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<_SectionWidget> {
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
      onExpansionChanged: (value) => setState(() {}),
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
                    ? widget.isLastSubsection &&
                            (isFirstBuild || !controller.isExpanded)
                        ? const _UpAndRightBoxDrawingWidget()
                        : const _VerticalAndRightBoxDrawingWidget()
                    : const _VerticalBoxDrawingWidget(),
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
              .map((e) => _SectionWidget(
                    sectionHasCheckBoxBuilder: (depth) => true,
                    section: e,
                    depth: widget.depth + 1,
                    isLastSubsection:
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

class _VerticalBoxDrawingWidget extends StatelessWidget {
  const _VerticalBoxDrawingWidget();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyLarge?.color;
    return VerticalDivider(
      color: color,
      width: 1.0,
      thickness: 1.0,
    );
  }
}

class _VerticalAndRightBoxDrawingWidget extends StatelessWidget {
  const _VerticalAndRightBoxDrawingWidget();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyLarge?.color;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VerticalDivider(
          color: color,
          width: 1.0,
          thickness: 1.0,
        ),
        SizedBox(
          width: 12,
          child: Divider(
            color: color,
            thickness: 1.0,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class _UpAndRightBoxDrawingWidget extends StatelessWidget {
  const _UpAndRightBoxDrawingWidget();

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
                        ? const _UpAndRightBoxDrawingWidget()
                        : const _VerticalAndRightBoxDrawingWidget()
                    : const _VerticalBoxDrawingWidget(),
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
