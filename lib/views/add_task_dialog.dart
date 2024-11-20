import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';
import '../constants/app_strings.dart';

class AddTaskDialog extends StatefulWidget {
  final List<String> categories;

  const AddTaskDialog({Key? key, required this.categories}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late String _selectedCategory;
  int _urgency = 1;
  int _importance = 1;
  DateTime _reminderTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first;
  }

  void _addTask() {
  if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
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
}


  @override
  @override
Widget build(BuildContext context) {
  return AlertDialog(
    title: const Text('Add New Task'),
    content: SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: widget.categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) => setState(() {
              _selectedCategory = value!;
            }),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Urgency:'),
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
              const Text('Importance:'),
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
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: _addTask, // This calls the method to add the task
        child: const Text('Add Task'), // Add Task button
      ),
    ],
  );
}

}
