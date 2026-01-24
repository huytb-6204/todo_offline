# Project Context: Full Code Snapshot

This file contains the current source code for key project files.
Included: README, pubspec, analysis options, and all Dart files under lib/.

## `README.md`

```markdown
# todo_offline

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
```

## `pubspec.yaml`

```yaml
name: todo_offline
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.9.2

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.3
  json_annotation: ^4.9.0


dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^5.0.0
  build_runner: ^2.4.11
  json_serializable: ^6.8.0


# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package
```

## `analysis_options.yaml`

```yaml
# This file configures the analyzer, which statically analyzes Dart code to
# check for errors, warnings, and lints.
#
# The issues identified by the analyzer are surfaced in the UI of Dart-enabled
# IDEs (https://dart.dev/tools#ides-and-editors). The analyzer can also be
# invoked from the command line by running `flutter analyze`.

# The following line activates a set of recommended lints for Flutter apps,
# packages, and plugins designed to encourage good coding practices.
include: package:flutter_lints/flutter.yaml

linter:
  # The lint rules applied to this project can be customized in the
  # section below to disable rules from the `package:flutter_lints/flutter.yaml`
  # included above or to enable additional rules. A list of all available lints
  # and their documentation is published at https://dart.dev/lints.
  #
  # Instead of disabling a lint rule for the entire project in the
  # section below, it can also be suppressed for a single line of code
  # or a specific dart file by using the `// ignore: name_of_lint` and
  # `// ignore_for_file: name_of_lint` syntax on the line or in the file
  # producing the lint.
  rules:
    # avoid_print: false  # Uncomment to disable the `avoid_print` rule
    # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule

# Additional information about this file can be found at
# https://dart.dev/guides/language/analysis-options
```

## `lib/ app.dart`

```dart
import 'package:flutter/material.dart';
import 'screens/task_list_screen.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Offline Todo App',
        debugShowCheckedModeBanner: false,
        home: const TaskListScreen(),
    );
  }
}


```

## `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import ' app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}
```

## `lib/models/task-filter.dart`

```dart
  enum TaskFilter {
    all,done, undone
  }
```

## `lib/models/task.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';



@JsonSerializable()
class Task {
  final String id;
  final String title;
  final String? description;
  @JsonKey(defaultValue: false)
  final bool isDone;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.isDone = false,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);


}
```

## `lib/models/task.g.dart`

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  isDone: json['isDone'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'isDone': instance.isDone,
  'createdAt': instance.createdAt.toIso8601String(),
};
```

## `lib/repositories/task_repository.dart`

```dart
import '../models/task.dart';
import '../services/task_storage.dart';

/// Repository = tầng trung gian giữa UI và Storage.
/// UI không cần biết lưu bằng SharedPreferences hay SQLite.
/// Sau này đổi storage (SQLite) chỉ đổi ở repo/storage, UI ít phải sửa.
class TaskRepository {
  final TaskStorage _storage;


  TaskRepository({
    TaskStorage ? storage
  }) : _storage = storage ?? TaskStorage();

  Future<List<Task>> loadTasks() => _storage.loadTasks();


  Future<void> saveTasks(List<Task> tasks) => _storage.saveTasks(tasks);

}


```

## `lib/screens/task_form_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? initial;

  const TaskFormScreen({super.key, this.initial});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtl;
  late final TextEditingController _descCtl;

  @override
  void initState() {
    super.initState();
    _titleCtl = TextEditingController(text: widget.initial?.title ?? '');
    _descCtl = TextEditingController(text: widget.initial?.description ?? '');
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleCtl.text.trim();
    final desc = _descCtl.text.trim();
    final now = DateTime.now();

    final result = (widget.initial == null) ?
      Task(
        id: now.microsecondsSinceEpoch.toString(),
        title: title,
        description: desc,
        createdAt: now,
      ) : widget.initial!.copyWith(
        title: title,
        description: desc.isEmpty ? null : desc,  
      );  


      Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdited = widget.initial != null;


    return Scaffold(
      appBar: AppBar(
        title: Text(isEdited ? 'Edit Task' : 'New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _titleCtl,
                decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),


              const SizedBox(height: 12.0),
              TextFormField(
                controller: _descCtl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
              ),


              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              )



            ],
          ),
        ),
      ),
    );
  }

}
```

## `lib/screens/task_list_screen.dart`

```dart
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


  List<Task> get_VisibleTasks() {
    switch (_filter) {
      case TaskFilter.all:
        return _tasks;
      case TaskFilter.done:
        return _tasks.where((task) => task.isDone).toList();
      case TaskFilter.undone:
        return _tasks.where((task) => !task.isDone).toList();
      default:
        return [];
    }
  
  }

  /// Load danh sách task từ SharedPreferences (async)
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

  /// Save danh sách task xuống SharedPreferences (async)
  Future<void> _saveTasks() async {
    await _repository.saveTasks(_tasks);
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



  /// Xoá task theo index
  Future<void> _deleteTask(int index) async {
    setState(() => _tasks.removeAt(index));
    await _saveTasks();
  }


    /// Toggle done/undone
  Future<void> _toggleDone(int index, bool value) async {
    final task = _tasks[index];
    setState(() => _tasks[index] = task.copyWith(isDone: value));
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
```

## `lib/services/task_storage.dart`

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStorage {
  // Versioned key to handle future schema changes
  static const _key = 'tasks_v1';   

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}
```

## `lib/widgets/task_tile.dart`

```dart
import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onTap;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Checkbox(value: task.isDone, onChanged: onToggle),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: task.description == null ? null : Text(task.description!),
    );
  }
}
```
