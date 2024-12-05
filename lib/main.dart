import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/task_view_model.dart';
import 'views/tasks_page.dart';
import 'services/notification_service.dart';
import 'viewmodels/category_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize(); // Bildirim servisini başlat
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()..loadCategories()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
