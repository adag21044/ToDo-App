import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import 'task_list_tab.dart';
import 'add_task_dialog.dart';
import '../viewmodels/category_view_model.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskViewModel>(context, listen: false).loadTasks();
    });
  }

  void _addNewCategory() {
    final TextEditingController newListController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Liste Ekle'),
          content: TextField(
            controller: newListController,
            decoration: const InputDecoration(
              labelText: 'Liste Adı',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newListController.text.isNotEmpty) {
                  Provider.of<CategoryViewModel>(context, listen: false)
                      .addCategory(newListController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoryViewModel>(context).categories;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Görevler',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
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
            tabs: categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories
              .map((category) => TaskListTab(category: category))
              .toList(),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          final categories = Provider.of<CategoryViewModel>(context, listen: false).categories;
          showDialog(
            context: context,
            builder: (_) => AddTaskDialog(categories: categories),
          );
        },
        child: const Icon(Icons.add),
      ),

      ),
    );
  }
}
