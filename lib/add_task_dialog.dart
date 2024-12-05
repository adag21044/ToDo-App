import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';


class AddTaskDialog extends StatefulWidget {
  final List<String> categories;

  const AddTaskDialog({Key? key, required this.categories}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}


class _AddTaskDialogState extends State<AddTaskDialog> {


  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'My Tasks';
  final List<String> _categories = ['My Tasks', 'Project Ideas', 'A', 'Daily'];
  int _urgency = 1;
  int _importance = 1;
  DateTime _reminderTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: const Color(0xFF1E1E2C),
      title: const Text(
        'Add New Task',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.teal),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.teal),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
              dropdownColor: const Color(0xFF1E1E2C),
              decoration: const InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: Colors.teal),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Urgency:', style: TextStyle(color: Colors.teal)),
                Expanded(
                  child: Slider(
                    value: _urgency.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _urgency.toString(),
                    onChanged: (value) {
                      setState(() {
                        _urgency = value.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Importance:', style: TextStyle(color: Colors.teal)),
                Expanded(
                  child: Slider(
                    value: _importance.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _importance.toString(),
                    onChanged: (value) {
                      setState(() {
                        _importance = value.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _reminderTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_reminderTime),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      _reminderTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                }
              },
              child: const Text('Set Reminder Time'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.teal)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty) {
              final task = Task(
              title: _titleController.text,
              description: _descriptionController.text,
              category: _selectedCategory,
              reminderTime: _reminderTime,
              urgency: _urgency,
              importance: _importance,
              subtasks: [], // Explicitly initialize subtasks as an empty list
            );

              Provider.of<TaskViewModel>(context, listen: false).addTask(task);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class TaskDetailsPage extends StatelessWidget {
  final Task task;

  const TaskDetailsPage({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Category: ${task.category}'),
            const SizedBox(height: 10),
            Text('Urgency: ${task.urgency}'),
            const SizedBox(height: 10),
            Text('Importance: ${task.importance}'),
            const SizedBox(height: 10),
            Text('Reminder: ${task.reminderTime}'),
          ],
        ),
      ),
    );
  }
}
