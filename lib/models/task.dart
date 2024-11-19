class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime reminderTime;
  final int urgency;
  final int importance;
  final String category;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.reminderTime,
    required this.urgency,
    required this.importance,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'reminderTime': reminderTime.toIso8601String(),
      'urgency': urgency,
      'importance': importance,
      'category': category,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      reminderTime: DateTime.parse(map['reminderTime'] as String),
      urgency: map['urgency'] as int,
      importance: map['importance'] as int,
      category: map['category'] as String,
    );
  }
}
