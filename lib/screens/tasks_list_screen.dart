import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task-filter.dart';
import '../repositories/task_repository.dart';
import '../widgets/task_tile.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskRepository _repository = TaskRepository();

  final List<Task> _tasks = [];
  bool _loading = true;

  TaskFilter _filter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // ===== Filtered view =====
  List<Task> get _visibleTasks {
    switch (_filter) {
      case TaskFilter.all:
        return _tasks;
      case TaskFilter.done:
        return _tasks.where((task) => task.isDone).toList();
      case TaskFilter.undone:
        return _tasks.where((task) => !task.isDone).toList();
    }
  }

  int _indexOfTaskId(String id) => _tasks.indexWhere((t) => t.id == id);

  // ===== Persistence =====
  Future<void> _loadTasks() async {
    final loaded = await _repository.loadTasks();
    if (!mounted) return;

    setState(() {
      _tasks
        ..clear()
        ..addAll(loaded);
      _loading = false;
    });
  }

  Future<void> _saveTasks() async {
    await _repository.saveTasks(_tasks);
  }

  // ===== CRUD =====
  Future<void> _addTask() async {
    final Task? created = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const TaskFormScreen()),
    );
    if (created == null) return;

    setState(() => _tasks.insert(0, created));
    await _saveTasks();
  }

  Future<void> _editTaskById(String id) async {
    final index = _indexOfTaskId(id);
    if (index == -1) return;

    final current = _tasks[index];

    final Task? edited = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => TaskFormScreen(initial: current)),
    );
    if (edited == null) return;

    setState(() => _tasks[index] = edited);
    await _saveTasks();
  }

  Future<void> _deleteTaskById(String id) async {
    final index = _indexOfTaskId(id);
    if (index == -1) return;

    setState(() => _tasks.removeAt(index));
    await _saveTasks();
  }

  Future<void> _toggleDoneById(String id, bool value) async {
    final index = _indexOfTaskId(id);
    if (index == -1) return;

    final task = _tasks[index];
    setState(() => _tasks[index] = task.copyWith(isDone: value));
    await _saveTasks();
  }

// ===== UI =====
Widget _buildFilterBar() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: SegmentedButton<TaskFilter>(
      segments: const [
        ButtonSegment(value: TaskFilter.all, label: Text('All')),
        ButtonSegment(value: TaskFilter.undone, label: Text('Undone')),
        ButtonSegment(value: TaskFilter.done, label: Text('Done')),
      ],
      selected: {_filter},
      onSelectionChanged: (set) {
        setState(() => _filter = set.first);
      },
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final visible = _visibleTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Offline'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilterBar(),
                const Divider(height: 1),
                Expanded(
                  child: _tasks.isEmpty
                      ? const Center(
                          child: Text('No tasks yet. Tap + to add one.'),
                        )
                      : visible.isEmpty
                          ? const Center(
                              child: Text('No tasks match this filter.'),
                            )
                          : ListView.builder(
                              itemCount: visible.length,
                              itemBuilder: (context, index) {
                                final task = visible[index];

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
                                  onDismissed: (_) => _deleteTaskById(task.id),
                                  child: TaskTile(
                                    task: task,
                                    onTap: () => _editTaskById(task.id),
                                    onToggle: (v) =>
                                        _toggleDoneById(task.id, v ?? false),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
