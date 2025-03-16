import 'package:hive_flutter/hive_flutter.dart';

part 'todo_definition.g.dart';

@HiveType(typeId: 1)
class TodoDefinition extends HiveObject {
  @HiveField(0)
  final String type;
  
  @HiveField(1)
  final String style;
  
  @HiveField(2)
  final String color;
  
  @HiveField(3)
  final String action;

  TodoDefinition({
    required this.type,
    required this.style,
    required this.color,
    required this.action,
  });

  factory TodoDefinition.fromJson(Map<String, dynamic> json) {
    return TodoDefinition(
      type: json['type'] ?? '',
      style: json['style'] ?? '',
      color: json['color'] ?? '',
      action: json['action'] ?? '',
    );
  }
}