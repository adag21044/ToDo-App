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
  }) : subtasks = subtasks ?? []; // Ensure subtasks defaults to an empty list
}

