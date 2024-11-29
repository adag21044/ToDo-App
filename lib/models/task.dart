import 'subtask.dart';

class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime reminderTime;
  final int urgency;
  final int importance;
  final String category;
  bool isCompleted;
  List<Subtask> subtasks;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.reminderTime,
    required this.urgency,
    required this.importance,
    required this.category,
    this.isCompleted = false,
    List<Subtask>? subtasks,
  }) : subtasks = subtasks ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'reminderTime': reminderTime.toIso8601String(),
      'urgency': urgency,
      'importance': importance,
      'category': category,
      'isCompleted': isCompleted,
      'subtasks': subtasks.map((subtask) => subtask.toJson()).toList(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      return Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        reminderTime: DateTime.parse(json['reminderTime']),
        urgency: json['urgency'],
        importance: json['importance'],
        category: json['category'],
        isCompleted: json['isCompleted'],
        subtasks: (json['subtasks'] as List)
            .map((subtask) => Subtask.fromJson(subtask))
            .toList(),
      );
    } catch (e) {
      print('Error parsing task from JSON: $e');
      throw e; // Rethrow error to detect during development
    }
  }

}

