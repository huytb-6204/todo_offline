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
