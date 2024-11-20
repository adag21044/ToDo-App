import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';
import 'task_details_page.dart';

class TaskListTab extends StatelessWidget {
  final String category;

  const TaskListTab({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskViewModel>(context)
        .tasks
        .where((task) => task.category == category)
        .toList()
      ..sort((a, b) {
        int importanceComparison = b.importance.compareTo(a.importance);
        if (importanceComparison != 0) {
          return importanceComparison;
        }
        return b.urgency.compareTo(a.urgency);
      });

    return tasks.isEmpty
        ? const Center(
            child: Text(
              'Henüz bir görev eklenmedi.',
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
                    value: task.isCompleted,
                    onChanged: (value) {
                      Provider.of<TaskViewModel>(context, listen: false)
                          .toggleTaskCompletion(task);
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    task.description,
                    style: TextStyle(
                      color: task.isCompleted ? Colors.grey : Colors.white70,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Provider.of<TaskViewModel>(context, listen: false)
                          .removeTask(task);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailsPage(task: task),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
