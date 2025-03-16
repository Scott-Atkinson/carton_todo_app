import 'dart:convert';

import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:http/http.dart' as http;

class TodoApiClient {
  final String baseUrl = 'https://my.api.mockaroo.com';
  final String apiKey = 'fac54c20';
  
  Future<List<Todo>> fetchTodos({int page = 0}) async {
    try {
      // Now using proper pagination with the API
      final response = await http.get(
        Uri.parse('$baseUrl/todos?page=$page'),
        headers: {'X-API-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((todoJson) => Todo.fromJson(todoJson)).toList();
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching todos: $e');
    }
  }

  Future<List<TodoDefinition>> fetchTodoDefinitions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/todo/definition'),
        headers: {'X-API-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((defJson) => TodoDefinition.fromJson(defJson)).toList();
      } else {
        throw Exception('Failed to load todo definitions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching todo definitions: $e');
    }
  }
  
  Future<bool> updateTodoStatus(String todoId, String actionKey) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/todo/action'),
        headers: {
          'X-API-Key': apiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "task": todoId,
          "action": actionKey
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating todo: $e');
    }
  }
}

