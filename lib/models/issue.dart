class Issue {
  final int? id;
  final String deviceType;
  final String issueName;
  final String possibleCauses;
  final String solutions;
  final String warnings;

  Issue({
    this.id,
    required this.deviceType,
    required this.issueName,
    required this.possibleCauses,
    required this.solutions,
    required this.warnings,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'] as int?,
      deviceType: json['device_type'] as String,
      issueName: json['issue_name'] as String,
      possibleCauses: json['possible_causes'] as String,
      solutions: json['solutions'] as String,
      warnings: json['warnings'] as String,
    );
  }

  List<String> get causesList {
    return possibleCauses.split('\n').where((s) => s.trim().isNotEmpty).toList();
  }

  List<String> get solutionsList {
    return solutions.split('\n').where((s) => s.trim().isNotEmpty).toList();
  }

  List<String> get warningsList {
    return warnings.split('\n').where((s) => s.trim().isNotEmpty).toList();
  }
}
