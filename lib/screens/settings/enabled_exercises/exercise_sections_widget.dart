import 'package:flutter/material.dart';
import 'package:uchu/screens/settings/enabled_exercises/exercise_section.dart';
import 'package:uchu/screens/settings/enabled_exercises/section_widget.dart';

class ExerciseSectionsWidget extends StatefulWidget {
  const ExerciseSectionsWidget({
    super.key,
    required this.sections,
  });
  final List<ExerciseSection> sections;

  @override
  State<ExerciseSectionsWidget> createState() => _ExerciseSectionsWidgetState();
}

class _ExerciseSectionsWidgetState extends State<ExerciseSectionsWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: widget.sections.length,
      itemBuilder: (context, index) {
        return SectionWidget(
          sectionHasCheckBoxBuilder: (depth) => true,
          section: widget.sections[index],
          isLastSubsection: index == widget.sections.length - 1,
        );
      },
    );
  }
}
