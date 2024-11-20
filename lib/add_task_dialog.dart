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
  String _category = 'Günlük';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text('Yeni Görev Ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Başlık'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Açıklama'),
          ),
          DropdownButtonFormField(
            value: _category,
            items: []
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) => setState(() => _category = value as String),
            decoration: const InputDecoration(labelText: 'Kategori'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              final task = Task(
                title: _titleController.text,
                description: _descriptionController.text,
                category: _category,
                reminderTime: DateTime.now(),
                urgency: 1,
                importance: 1,
              );
              Provider.of<TaskViewModel>(context, listen: false).addTask(task);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}
