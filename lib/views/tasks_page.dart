import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import 'add_task_dialog.dart';
import 'task_list_tab.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Görevler'),
          bottom: const TabBar(
            isScrollable: true, // Allows scrolling if there are many tabs
            tabs: [
              Tab(text: 'My Tasks'),
              Tab(text: 'Project Ideas'),
              Tab(text: 'A'),
              Tab(text: 'Daily'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TaskListTab(category: 'My Tasks'),
            TaskListTab(category: 'Project Ideas'),
            TaskListTab(category: 'A'),
            TaskListTab(category: 'Daily'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AddTaskDialog(),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
