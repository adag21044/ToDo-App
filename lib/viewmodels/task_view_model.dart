import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../models/subtask.dart';

class TaskViewModel extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  // Add a task
  void addTask(Task task) {
    _tasks.add(task); // Subtasks are already initialized
    notifyListeners();
  }

  // Remove a task
  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  // Toggle task completion
  void toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  // Add a subtask to a task
  void addSubtask(Task task, Subtask subtask) {
    task.subtasks.add(subtask);
    notifyListeners();
  }

  // Toggle subtask completion
  void toggleSubtaskCompletion(Task task, Subtask subtask) {
    subtask.isCompleted = !subtask.isCompleted;
    notifyListeners();
  }
}
