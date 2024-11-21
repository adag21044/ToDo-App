import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task task;

  const TaskDetailsPage({Key? key, required this.task}) : super(key: key);

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

  Widget _buildCircularIndicator(String label, int value) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value / 5,
                color: _getColorForLevel(value),
                backgroundColor: Colors.grey.shade300,
                strokeWidth: 8,
              ),
              Center(
                child: Text(
                  value.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularIndicator("Urgency", task.urgency),
                _buildCircularIndicator("Importance", task.importance),
              ],
            ),
            const SizedBox(height: 20),
            Text('Category: ${task.category}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Reminder: ${task.reminderTime}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
