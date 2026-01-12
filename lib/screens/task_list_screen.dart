import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_storage.dart';
import '../widgets/task_tile.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskStorage _storage = TaskStorage();

  final List<Task> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  /// Load danh sách task từ SharedPreferences (async)
  Future<void> _loadTasks() async {
    final loaded = await _storage.loadTasks();
    if (!mounted) return;

    setState(() {
      _tasks
        ..clear()
        ..addAll(loaded);
      _loading = false;
    });
  }

  /// Save danh sách task xuống SharedPreferences (async)
  Future<void> _saveTasks() async {
    await _storage.saveTasks(_tasks);
  }

  /// Thêm task: mở form -> nhận Task trả về -> insert -> save
  Future<void> _addTask() async {
    final Task? created = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const TaskFormScreen()),
    );
    if (created == null) return;

    setState(() => _tasks.insert(0, created));
    await _saveTasks();
  }

  /// Sửa task: mở form với initial -> nhận Task trả về -> update -> save
  Future<void> _editTask(int index) async {
    final current = _tasks[index];

    final Task? edited = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => TaskFormScreen(initial: current)),
    );
    if (edited == null) return;

    setState(() => _tasks[index] = edited);
    await _saveTasks();
  }

  /// Toggle done/undone
  Future<void> _toggleDone(int index, bool value) async {
    final task = _tasks[index];
    setState(() => _tasks[index] = task.copyWith(isDone: value));
    await _saveTasks();
  }

  /// Xoá task theo index
  Future<void> _deleteTask(int index) async {
    setState(() => _tasks.removeAt(index));
    await _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Offline'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('No tasks yet. Tap + to add one.'))
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];

                    return Dismissible(
                      key: ValueKey(task.id),
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.delete),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.delete),
                      ),
                      onDismissed: (_) => _deleteTask(index),
                      child: TaskTile(
                        task: task,
                        onTap: () => _editTask(index),
                        onToggle: (v) => _toggleDone(index, v ?? false),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
