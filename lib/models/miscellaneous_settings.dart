import 'package:equatable/equatable.dart';

class MiscellaneousSettings extends Equatable {
  final bool automaticallyShowExplanation;

  const MiscellaneousSettings({required this.automaticallyShowExplanation});

  factory MiscellaneousSettings.defaultSettings() {
    return const MiscellaneousSettings(automaticallyShowExplanation: false);
  }

  MiscellaneousSettings copyWith({bool? automaticallyShowExplanation}) {
    return MiscellaneousSettings(
      automaticallyShowExplanation:
          automaticallyShowExplanation ?? this.automaticallyShowExplanation,
    );
  }

  factory MiscellaneousSettings.fromJson(Map<String, dynamic> json) {
    return MiscellaneousSettings(
      automaticallyShowExplanation:
          json['automaticallyShowExplanation'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'automaticallyShowExplanation': automaticallyShowExplanation,
    };
  }

  @override
  List<Object?> get props => [automaticallyShowExplanation];
}
