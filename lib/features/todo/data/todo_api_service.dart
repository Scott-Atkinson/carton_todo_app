import 'package:carton_todo_app/core/api/api_client.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';

class TodoApiService {
  final ApiClient _apiClient;
  
  TodoApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  
  Future<List<Todo>> fetchTodos({int page = 0}) async {
    final jsonData = await _apiClient.get('todos', queryParams: {'page': '$page'});
    
    if (jsonData is List) {
      return jsonData.map((todoJson) => Todo.fromJson(todoJson)).toList();
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<List<TodoDefinition>> fetchTodoDefinitions() async {
    final jsonData = await _apiClient.get('todo/definition');
    
    if (jsonData is List) {
      return jsonData.map((defJson) => TodoDefinition.fromJson(defJson)).toList();
    } else {
      throw Exception('Unexpected response format');
    }
  }
  
  Future<bool> updateTodoStatus(String todoId, String actionKey) async {
    final result = await _apiClient.post(
      'todo/action', 
      body: {
        "task": todoId,
        "action": actionKey
      }
    );
    
    return result is bool ? result : true;
  }
}
