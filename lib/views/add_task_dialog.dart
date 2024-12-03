import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';
import '../services/notification_service.dart';

class AddTaskDialog extends StatefulWidget {
  final List<String> categories; // Added categories parameter

  const AddTaskDialog({Key? key, required this.categories}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late String _selectedCategory; // Initialize with categories from the parent
  int _urgency = 1;
  int _importance = 1;
  DateTime _reminderTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first; // Default to the first category
  }

  void _addTask() async {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      final task = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        reminderTime: _reminderTime,
        urgency: _urgency,
        importance: _importance,
        subtasks: [],
      );

      // Add task to TaskViewModel
      Provider.of<TaskViewModel>(context, listen: false).addTask(task);

      // Schedule a notification for the task
      await NotificationService().scheduleNotification(
        id: task.hashCode, // Use a unique ID for each task
        title: 'Reminder: ${task.title}',
        body: task.description,
        scheduledDate: task.reminderTime,
        payload: {
          'task_title': task.title, // Include task title or other details in the payload
        },
      );

      Navigator.pop(context);
    }
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
              items: widget.categories
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
          onPressed: _addTask,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
