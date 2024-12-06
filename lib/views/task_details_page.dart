import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  const TaskDetailsPage({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final _subtaskController = TextEditingController();

  void _addSubtask() {
    final title = _subtaskController.text.trim();
    if (title.isNotEmpty) {
      setState(() {
        widget.task.subtasks.add(Subtask(title: title));
      });
      _subtaskController.clear();
      Provider.of<TaskViewModel>(context, listen: false).saveTask(widget.task);
    }
  }

  Color _getColorForLevel(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Urgency', style: TextStyle(fontSize: 16)),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: _getColorForLevel(widget.task.urgency),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Importance', style: TextStyle(fontSize: 16)),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: _getColorForLevel(widget.task.importance),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.task.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Subtasks:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.task.subtasks.length,
                itemBuilder: (context, index) {
                  final subtask = widget.task.subtasks[index];
                  return ListTile(
                    leading: Checkbox(
                      value: subtask.isCompleted,
                      onChanged: (value) {
                        setState(() {
                          subtask.isCompleted = value!;
                        });
                        Provider.of<TaskViewModel>(context, listen: false)
                            .saveTask(widget.task);
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
                },
              ),
            ),
            TextField(
              controller: _subtaskController,
              decoration: InputDecoration(
                hintText: 'Add subtasks',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addSubtask, // '+' butonuna basınca çalışır
                ),
              ),
              onSubmitted: (value) => _addSubtask(), // Enter'a basınca çalışır
            ),
          ],
        ),
      ),
    );
  }
}
