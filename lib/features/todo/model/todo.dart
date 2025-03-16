import 'package:hive_flutter/hive_flutter.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String type;
  
  @HiveField(4)
  final bool completed;
  
  @HiveField(5)
  final DateTime? dueDate;
  
  @HiveField(6)
  final DateTime? startTime;
  
  @HiveField(7)
  final DateTime? finishTime;
  
  @HiveField(8)
  final String? phone;
  
  @HiveField(9)
  final String? url;
  
  @HiveField(10)
  final String? location;
  
  @HiveField(11)
  final DateTime? createdAt;
  
  @HiveField(12)
  final DateTime? updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.completed,
    this.dueDate,
    this.startTime,
    this.finishTime,
    this.phone,
    this.url,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      completed: json['completed'] == '1',
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      startTime: json['start_time'] != null ? DateTime.parse(json['start_time']) : null,
      finishTime: json['finish_time'] != null ? DateTime.parse(json['finish_time']) : null,
      phone: json['phone'],
      url: json['url'],
      location: json['location'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}