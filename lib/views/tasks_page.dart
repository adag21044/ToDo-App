import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import 'task_list_tab.dart';
import 'add_task_dialog.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<String> _categories = ['My Tasks', 'Project Ideas', 'A', 'Daily'];

  void _addNewCategory() {
    TextEditingController newListController = TextEditingController();
    showDialog( 
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New List'),
          content: TextField(
            controller: newListController,
            decoration: const InputDecoration(labelText: 'List Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newListController.text.isNotEmpty) {
                  setState(() {
                    _categories.add(newListController.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Tasks'),
          actions: [
            TextButton(
              onPressed: _addNewCategory,
              child: const Text(
                '+ Yeni Liste',
                style: TextStyle(color: Colors.teal, fontSize: 16),
              ),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: _categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: TabBarView(
          children: _categories
              .map((category) => TaskListTab(category: category))
              .toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AddTaskDialog(),
            );
          },
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
