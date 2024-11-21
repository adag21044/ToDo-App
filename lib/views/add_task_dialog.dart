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
  late String _selectedCategory;
  int _urgency = 1;
  int _importance = 1;
  DateTime _reminderTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first;
  }

  /// Metodu tanımlıyoruz
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

  void _addTask() {
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

      Provider.of<TaskViewModel>(context, listen: false).addTask(task);
      Navigator.pop(context);
    }
  }

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
                CircleAvatar(
                  radius: 10,
                  backgroundColor: _getColorForLevel(_urgency),
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
                CircleAvatar(
                  radius: 10,
                  backgroundColor: _getColorForLevel(_importance),
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
          onPressed: _addTask,
          child: const Text('Add Task'),
        ),
      ],
    );
  }
}
