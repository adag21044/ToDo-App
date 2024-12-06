import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../viewmodels/task_view_model.dart';
import '../services/notification_service.dart';

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
  int _urgency = 1;
  int _importance = 1;
  DateTime _reminderTime = DateTime.now();
  List<Subtask> subtasks = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first;
  }

  Future<void> _selectDateTime() async {
    // Kullanıcının tarih seçmesini sağla
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      // Kullanıcının saat seçmesini sağla
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminderTime),
      );
      if (pickedTime != null) {
        setState(() {
          _reminderTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _addTask() async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      final task = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        reminderTime: _reminderTime,
        urgency: _urgency,
        importance: _importance,
        subtasks: subtasks,
      );

      // Görevi kaydet
      Provider.of<TaskViewModel>(context, listen: false).addTask(task);

      // Bildirim planla
      await NotificationService().scheduleNotification(
        id: task.hashCode,
        title: 'Reminder: ${task.title}',
        body: task.description,
        scheduledDate: _reminderTime,
        payload: {'task_title': task.title},
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
            // Görev başlığı
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
            // Görev açıklaması
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
            // Kategori seçimi
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
            // Urgency ve Importance Slider'ları
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
            // Alt görev ekleme
            TextField(
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    subtasks.add(Subtask(title: value));
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Add Subtask',
                suffixIcon: Icon(Icons.add),
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
            ...subtasks.map((subtask) => ListTile(
                  title: Text(
                    subtask.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Checkbox(
                    value: subtask.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        subtask.isCompleted = value!;
                      });
                    },
                  ),
                )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectDateTime,
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
