import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/services/shared_preferences_service.dart';

class WordFormSection {
  const WordFormSection(
      {required this.title, this.subSections, this.wordFormTypes})
      : assert(subSections == null || wordFormTypes == null,
            'WordFormSection cannot have both subSections and wordForms');
  final String title;
  final List<WordFormSection>? subSections;
  final List<(WordFormType, String)>? wordFormTypes;
}

class WordFormSectionsWidget extends StatefulWidget {
  const WordFormSectionsWidget({
    super.key,
    required this.sections,
  });
  final List<WordFormSection> sections;

  @override
  State<WordFormSectionsWidget> createState() => _WordFormSectionsWidgetState();
}

class _WordFormSectionsWidgetState extends State<WordFormSectionsWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: widget.sections.length,
      itemBuilder: (context, index) {
        return _SectionWidget(
          section: widget.sections[index],
          isLastSubsection: index == widget.sections.length - 1,
        );
      },
    );
  }
}

class _SectionWidget extends StatefulWidget {
  const _SectionWidget(
      {required this.section, this.depth = 0, required this.isLastSubsection});
  final WordFormSection section;
  final int depth;
  final bool isLastSubsection;

  @override
  State<_SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<_SectionWidget> {
  final ExpansionTileController controller = ExpansionTileController();
  bool isFirstBuild = true;

  @override
  Widget build(BuildContext context) {
    final subSections = widget.section.subSections;
    final wordFormTypes = widget.section.wordFormTypes;
    final expansionTile = ExpansionTile(
      trailing: const SizedBox.shrink(),
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
                    section: e,
                    depth: widget.depth + 1,
                    isLastSubsection:
                        subSections.indexOf(e) == subSections.length - 1,
                  ))
              .toList()
          : wordFormTypes!.map(
              (e) {
                return SizedBox(
                  height: 36.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...List.generate(
                        widget.depth + 1,
                        (index) => Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: index == widget.depth
                              ? wordFormTypes.indexOf(e) ==
                                      wordFormTypes.length - 1
                                  ? const _UpAndRightBoxDrawingWidget()
                                  : const _VerticalAndRightBoxDrawingWidget()
                              : const _VerticalBoxDrawingWidget(),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: InkWell(
                          child: Row(
                            children: [
                              Text(e.$2),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: IgnorePointer(
                                  child: SizedBox.square(
                                    dimension: Checkbox.width,
                                    child: Checkbox(
                                      value: GetIt.instance
                                          .get<SharedPreferencesService>()
                                          .getWordFormTypeEnabled(e.$1),
                                      onChanged: (_) {},
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              GetIt.instance
                                  .get<SharedPreferencesService>()
                                  .toggleWordFormTypeEnabled(e.$1);
                            });
                          },
                        ),
                      )
                    ],
                  ),
                );
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
