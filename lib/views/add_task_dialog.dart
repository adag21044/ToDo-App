import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({Key? key}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _reminderTime;
  final _categories = ['İş', 'Kişisel', 'Eğitim'];
  String _selectedCategory = 'İş';
  int _urgency = 1; // Varsayılan değer
  int _importance = 1; // Varsayılan değer

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

    return AlertDialog(
      title: const Text('Yeni Görev Ekle'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Başlık'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Açıklama'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((category) =>
                      DropdownMenuItem(value: category, child: Text(category)))
                  .toList(),
              onChanged: (value) => _selectedCategory = value!,
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),
            DropdownButtonFormField<int>(
              value: _urgency,
              items: [1, 2, 3]
                  .map((value) =>
                      DropdownMenuItem(value: value, child: Text('Aciliyet: $value')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _urgency = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Aciliyet'),
            ),
            DropdownButtonFormField<int>(
              value: _importance,
              items: [1, 2, 3]
                  .map((value) =>
                      DropdownMenuItem(value: value, child: Text('Önem: $value')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _importance = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Önem'),
            ),
            TextButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
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
              child: Text(_reminderTime == null
                  ? 'Hatırlatıcı Ayarla'
                  : _reminderTime.toString()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty &&
                _reminderTime != null) {
              final task = Task(
                title: _titleController.text,
                description: _descriptionController.text,
                reminderTime: _reminderTime!,
                category: _selectedCategory,
                urgency: _urgency,
                importance: _importance,
              );
              taskViewModel.addTask(task);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}
