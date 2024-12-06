import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../helpers/storage_helper.dart';

class TaskViewModel extends ChangeNotifier {
  final List<Task> _tasks = [];
  final StorageHelper _storageHelper = StorageHelper();

  List<Task> get tasks => List.unmodifiable(_tasks);

  TaskViewModel() {
    _init();
  }

  Future<void> _init() async {
    await loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final loadedTasks = await _storageHelper.loadTasks();
      _tasks
        ..clear()
        ..addAll(loadedTasks);
      print('Tasks loaded successfully: $_tasks'); // Debug log
      notifyListeners();
    } catch (e) {
      print('Error loading tasks in TaskViewModel: $e');
    }
  }

  void addTask(Task task) {
    if (!_tasks.any((t) => t.title == task.title && t.category == task.category)) {
      _tasks.add(task);
      print('Task added: ${task.toJson()}');
      _storageHelper.saveTasks(_tasks); // Save to local storage
      notifyListeners();
    } else {
      print('Task already exists: ${task.toJson()}');
    }
  }




  void removeTask(Task task) {
    _tasks.remove(task);
    print('Task removed: ${task.toJson()}'); // Debug log
    _storageHelper.saveTasks(_tasks); // Save after removing
    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    print('Task toggled: ${task.toJson()}'); // Debug log
    _storageHelper.saveTasks(_tasks); // Save after updating
    notifyListeners();
  }

  /// **Yeni Eklenen Metod: `saveTask`**
  /// Bu metod, bir görevi (ve alt görevlerini) güncellemek için kullanılır.
  void saveTask(Task updatedTask) {
    final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = updatedTask;
      print('Task updated: ${updatedTask.toJson()}');
      _storageHelper.saveTasks(_tasks);
      notifyListeners();
    }
  }
 

}
