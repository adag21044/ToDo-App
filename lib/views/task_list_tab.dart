import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';

class TaskListTab extends StatelessWidget {
  final String category;

  const TaskListTab({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskViewModel>(context)
        .tasks
        .where((task) => task.category == category)
        .toList();

    return tasks.isEmpty
        ? const Center(
            child: Text(
              'No tasks added yet.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: ListTile(
                  tileColor: const Color(0xFF1E1E2C),
                  leading: Checkbox(
                    value: task.isCompleted, // Null olmadığından emin ol
                    onChanged: (bool? value) {
                      if (value != null) {
                        Provider.of<TaskViewModel>(context, listen: false)
                            .toggleTaskCompletion(task);
                      }
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      color: task.isCompleted ? Colors.grey : Colors.white,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    task.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.star_border, color: Colors.teal),
                    onPressed: () {
                      // Favori ekleme fonksiyonelliği ekleyebilirsiniz
                    },
                  ),
                  onTap: () {
                    // Görev detayına gitme işlemi
                  },
                ),
              );
            },
          );
  }
}
