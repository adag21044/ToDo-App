import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/task_view_model.dart';
import 'views/tasks_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final taskViewModel = TaskViewModel();
  await taskViewModel.loadTasks(); // Ensure tasks are loaded at the start
  print('Tasks loaded on startup: ${taskViewModel.tasks}');
  runApp(
    ChangeNotifierProvider(
      create: (_) => taskViewModel,
      child: const ToDoApp(),
    ),
  );
}



class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Görevler',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1E1E2C),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E2C),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
        ),
      ),
      home: const TasksPage(),
    );
  }
}
