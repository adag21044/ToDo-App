import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryViewModel extends ChangeNotifier {
  List<String> _categories = ['My Tasks', 'Project Ideas', 'Daily', 'Work'];

  List<String> get categories => _categories;

  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCategories = prefs.getStringList('categories');
    if (savedCategories != null) {
      _categories = savedCategories;
      notifyListeners();
    }
  }

  Future<void> addCategory(String category) async {
    _categories.add(category);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('categories', _categories);
  }
}
