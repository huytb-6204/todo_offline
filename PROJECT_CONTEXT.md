# Project Context: todo_offline

Purpose
- Offline to-do list app built with Flutter.
- Persists tasks locally using SharedPreferences (JSON serialization).

Tech Stack
- Flutter + Dart (SDK ^3.9.2)
- Storage: shared_preferences
- JSON model generation: json_serializable + build_runner

How the App Works (high level)
- `lib/main.dart` initializes Flutter and runs the app.
- `lib/ app.dart` (note the leading space in the filename) builds `MaterialApp` with `TaskListScreen` as home.
- `TaskListScreen` loads tasks from the repository, renders a list, and handles add/edit/delete/toggle.
- `TaskFormScreen` is a form for creating or editing a task.
- `TaskRepository` mediates between UI and storage.
- `TaskStorage` saves/loads tasks in SharedPreferences under key `tasks_v1`.

Key Data Model
- `Task` (lib/models/task.dart)
  - Fields: `id`, `title`, `description?`, `isDone`, `createdAt`
  - JSON (de)serialization generated in `lib/models/task.g.dart`
- `TaskFilter` enum (lib/models/task-filter.dart): `all`, `done`, `undone`

Main UI Flow
- Task list:
  - Loads tasks asynchronously on init.
  - Shows spinner while loading.
  - Shows empty state if no tasks.
  - Uses `Dismissible` for delete.
  - Uses `TaskTile` widget for each item.
- Add task:
  - FAB opens `TaskFormScreen`.
  - On save: inserts new `Task` at top, persists list.
- Edit task:
  - Tap item opens `TaskFormScreen` with initial data.
  - On save: updates item in list, persists.
- Toggle done:
  - Checkbox toggles `isDone`, persists.

Repository / Storage
- `TaskRepository` abstracts storage and allows swapping backend later (e.g., SQLite).
- `TaskStorage` encodes list of tasks to JSON, stores via SharedPreferences.

Project Structure (relevant)
- `lib/main.dart` - app entry
- `lib/ app.dart` - MaterialApp + home screen (filename has leading space)
- `lib/models/` - `Task`, `TaskFilter`, generated JSON
- `lib/screens/` - `TaskListScreen`, `TaskFormScreen`
- `lib/services/` - `TaskStorage`
- `lib/repositories/` - `TaskRepository`
- `lib/widgets/` - `TaskTile`
- Platform folders: `android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/`

Notes / Quirks
- The file name `lib/ app.dart` includes a leading space and is imported as `import ' app.dart';` in `lib/main.dart`. This is uncommon and can be fragile if tools or scripts assume normal names.

File-by-File Details (selected core files)
- `lib/main.dart`
  - Initializes Flutter bindings, calls `runApp(const App())`.
  - Imports `lib/ app.dart` (leading space in filename).
- `lib/ app.dart`
  - Defines `App` (`StatelessWidget`).
  - Builds `MaterialApp` with:
    - title: "Offline Todo App"
    - debug banner disabled
    - home: `TaskListScreen`
- `lib/models/task.dart`
  - `Task` model with JSON serialization:
    - Fields: `id`, `title`, `description?`, `isDone` (default false), `createdAt`.
    - `copyWith` to clone/modify.
    - `fromJson` / `toJson` via generated code.
- `lib/models/task.g.dart`
  - Generated JSON serializer/deserializer for `Task`.
  - `createdAt` stored as ISO string.
- `lib/models/task-filter.dart`
  - `TaskFilter` enum: `all`, `done`, `undone`.
- `lib/services/task_storage.dart`
  - Wraps `SharedPreferences` persistence.
  - Uses key `tasks_v1`.
  - `loadTasks()`:
    - Reads JSON list from prefs.
    - Maps each item to `Task.fromJson`.
  - `saveTasks()`:
    - Encodes task list to JSON and saves to prefs.
- `lib/repositories/task_repository.dart`
  - Thin repository layer between UI and storage.
  - Delegates `loadTasks` and `saveTasks` to `TaskStorage`.
  - Allows swapping storage implementation later.
- `lib/screens/task_list_screen.dart`
  - Main screen, `StatefulWidget`.
  - State:
    - `_tasks` list (in-memory cache).
    - `_loading` boolean.
    - `_filter` (`TaskFilter`), currently used only in `get_VisibleTasks()` (not applied in UI list).
  - Lifecycle:
    - `initState()` calls `_loadTasks()`.
  - Methods:
    - `_loadTasks()` loads from repository and updates state.
    - `_saveTasks()` persists list.
    - `_addTask()` opens `TaskFormScreen`, inserts new task at top.
    - `_editTask(index)` opens `TaskFormScreen` with initial task, replaces item.
    - `_deleteTask(index)` removes item.
    - `_toggleDone(index, value)` updates `isDone`.
  - UI:
    - `AppBar` title "Todo Offline".
    - Body:
      - Spinner when loading.
      - Empty state text when no tasks.
      - `ListView.builder` with `Dismissible` + `TaskTile`.
    - `FloatingActionButton` adds new task.
- `lib/screens/task_form_screen.dart`
  - Form screen for create/edit.
  - Uses `TextEditingController` for title/description.
  - Validation:
    - Title required.
    - Description required (currently enforced).
  - On save:
    - If new: creates `Task` with new id + `createdAt`.
    - If edit: uses `copyWith` to update title/description.
    - Returns the created/edited task via `Navigator.pop`.
- `lib/widgets/task_tile.dart`
  - Stateless list item for task.
  - Shows checkbox, title with strikethrough when done, and optional description.
  - Triggers `onTap` (edit) and `onToggle` (done/undone).

Common Commands (if needed)
- Run app: `flutter run`
- Generate JSON serialization: `flutter pub run build_runner build --delete-conflicting-outputs`
