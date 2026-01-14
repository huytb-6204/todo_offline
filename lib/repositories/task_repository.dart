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


