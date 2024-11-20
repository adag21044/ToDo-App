import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../viewmodels/task_view_model.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task task;

  const TaskDetailsPage({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: Icon(Icons.star_border), // Placeholder for favorite
            onPressed: () {
              // Logic for favoriting the task
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for category
            DropdownButton<String>(
              value: task.category,
              items: ['My Tasks', 'Project Ideas', 'Daily', 'Work']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                // Update task category logic
              },
            ),
            const SizedBox(height: 16),

            // Task title and description
            Text(
              task.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              task.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Subtasks display section
            if (task.subtasks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Subtasks",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ...task.subtasks.map((subtask) {
                      return ListTile(
                        leading: Checkbox(
                          value: subtask.isCompleted,
                          onChanged: (value) {
                            Provider.of<TaskViewModel>(context, listen: false)
                                .toggleSubtaskCompletion(task, subtask);
                          },
                        ),
                        title: Text(
                          subtask.title,
                          style: TextStyle(
                            decoration: subtask.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

            // Add subtask button
            ListTile(
              leading: const Icon(Icons.subdirectory_arrow_right),
              title: const Text("Add Subtask"),
              onTap: () {
                final subtaskController = TextEditingController();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Add Subtask"),
                      content: TextField(
                        controller: subtaskController,
                        decoration: const InputDecoration(
                          labelText: "Subtask Title",
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (subtaskController.text.isNotEmpty) {
                              final newSubtask = Subtask(title: subtaskController.text);
                              Provider.of<TaskViewModel>(context, listen: false)
                                  .addSubtask(task, newSubtask);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Add"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const Spacer(),

            // Mark as completed button
            ElevatedButton(
              onPressed: () {
                Provider.of<TaskViewModel>(context, listen: false)
                    .toggleTaskCompletion(task);
                Navigator.pop(context);
              },
              child: const Text("Mark as Completed"),
            ),
          ],
        ),
      ),
    );
  }
}
