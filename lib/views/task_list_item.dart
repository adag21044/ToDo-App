import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({Key? key, required this.task}) : super(key: key);

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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: ListTile(
        tileColor: const Color(0xFF1E1E2C),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: _getColorForLevel(task.urgency),
            ),
            const SizedBox(height: 5),
            CircleAvatar(
              radius: 10,
              backgroundColor: _getColorForLevel(task.importance),
            ),
          ],
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: Colors.white,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          task.description,
          style: TextStyle(
            color: task.isCompleted ? Colors.grey : Colors.white70,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tik işareti (Checkbox)
            Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                Provider.of<TaskViewModel>(context, listen: false)
                    .toggleTaskCompletion(task);
              },
            ),
            // Çöp kutusu (Silme)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                Provider.of<TaskViewModel>(context, listen: false)
                    .removeTask(task);
              },
            ),
          ],
        ),
      ),
    );
  }
}
