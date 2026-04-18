import 'dart:convert';

class ScanHistoryItem {
  const ScanHistoryItem({
    required this.id,
    required this.imagePath,
    required this.disease,
    required this.description,
    required this.solution,
    required this.createdAt,
  });

  final String id;
  final String imagePath;
  final String disease;
  final String description;
  final String solution;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imagePath': imagePath,
      'disease': disease,
      'description': description,
      'solution': solution,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ScanHistoryItem.fromMap(Map<String, dynamic> map) {
    return ScanHistoryItem(
      id: map['id']?.toString() ?? '',
      imagePath: map['imagePath']?.toString() ?? '',
      disease: map['disease']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      solution: map['solution']?.toString() ?? '',
      createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ScanHistoryItem.fromJson(String source) {
    return ScanHistoryItem.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}
