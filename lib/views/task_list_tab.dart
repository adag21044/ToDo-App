import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';
import 'task_details_page.dart';

import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_details_page.dart';
import 'task_list_item.dart';

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
              'No tasks available.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailsPage(task: task),
                    ),
                  );
                },
                child: TaskListItem(task: task),
              );
            },
          );
  }
}
