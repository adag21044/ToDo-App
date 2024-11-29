import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../models/subtask.dart';

import '../helpers/storage_helper.dart';

class TaskViewModel extends ChangeNotifier {
  final List<Task> _tasks = [];
  final StorageHelper _storageHelper = StorageHelper();

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> loadTasks() async {
    final loadedTasks = await _storageHelper.loadTasks();
    _tasks.clear(); // Clear existing tasks
    _tasks.addAll(loadedTasks);
    notifyListeners();
  }


  void addTask(Task task) {
    _tasks.add(task);
    _storageHelper.saveTasks(_tasks); // Save after adding
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    _storageHelper.saveTasks(_tasks); // Save after removing
    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    _storageHelper.saveTasks(_tasks); // Save after updating
    notifyListeners();
  }
}
