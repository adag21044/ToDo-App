import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import 'add_task_dialog.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Görevler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddTaskDialog(),
              );
            },
          ),
        ],
      ),
      body: taskViewModel.tasks.isEmpty
          ? const Center(child: Text('Henüz bir görev eklenmedi.'))
          : ListView.builder(
              itemCount: taskViewModel.tasks.length,
              itemBuilder: (context, index) {
                final task = taskViewModel.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.category),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      taskViewModel.removeTask(task);
                    },
                  ),
                );
              },
            ),
    );
  }
}
