import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class StorageHelper {
  Future<String> get _filePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/tasks.json';
  }

  Future<File> get _file async {
    final path = await _filePath;
    return File(path);
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final file = await _file;
      final jsonTasks = tasks.map((task) => task.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonTasks));
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }


  Future<List<Task>> loadTasks() async {
    try {
      final file = await _file;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final jsonTasks = jsonDecode(contents) as List;
        print('Loaded tasks: $jsonTasks'); // Debug Log
        return jsonTasks.map((json) => Task.fromJson(json)).toList();
      } else {
        print('Task file does not exist.');
        return [];
      }
    } catch (e) {
      print('Error loading tasks: $e');
      return [];
    }
}

}
