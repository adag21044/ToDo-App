import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        .toList();

    return tasks.isEmpty
        ? const Center(
            child: Text(
              'No tasks added yet.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          )
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {
                      // Add favorite functionality if needed
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
