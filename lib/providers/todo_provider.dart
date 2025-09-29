import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TodoProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isOnboardingCompleted = false;
  bool _isLoading = true;

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isLoading => _isLoading;

  TodoProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;
      
      final tasksJson = prefs.getString('tasks');
      if (tasksJson != null) {
        final List<dynamic> tasksList = json.decode(tasksJson);
        _tasks = tasksList.map((item) => Task.fromMap(item)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading data: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    _isOnboardingCompleted = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingCompleted', true);
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    
    _tasks.add(newTask);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _saveTasks();
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      await _saveTasks();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = json.encode(_tasks.map((task) => task.toMap()).toList());
    await prefs.setString('tasks', tasksJson);
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _tasks.clear();
    _isOnboardingCompleted = false;
    notifyListeners();
  }
}