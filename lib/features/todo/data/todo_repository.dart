import 'package:carton_todo_app/features/todo/data/todo_api_service.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoRepository {
  final TodoApiService _apiService;
  Box<Todo>? _todoBox;
  Box<TodoDefinition>? _definitionBox;
  bool _hasReachedMax = false;
  bool get hasReachedMax => _hasReachedMax;

  // For testing purposes only
  List<Todo>? _todosForTesting;
  
  TodoRepository({TodoApiService? apiService}) 
      : _apiService = apiService ?? TodoApiService() {
    _initializeBoxes();
  }
  
  Future<void> _initializeBoxes() async {
    try {
      if (Hive.isBoxOpen('todos')) {
        _todoBox = Hive.box<Todo>('todos');
      } else {
        _todoBox = await Hive.openBox<Todo>('todos');
      }
      
      if (Hive.isBoxOpen('todoDefinitions')) {
        _definitionBox = Hive.box<TodoDefinition>('todoDefinitions');
      } else {
        _definitionBox = await Hive.openBox<TodoDefinition>('todoDefinitions');
      }
    } catch (e) {
      print('Unable to initialize Hive boxes: $e');
    }
  }

  Future<List<Todo>> fetchTodos({int page = 0, bool forceRefresh = false}) async {
    // For page 0, try to load from Hive first if not forcing refresh
    if (page == 0 && !forceRefresh && _todoBox != null && _todoBox!.isNotEmpty) {
      // We have local data, return it immediately
      // and optionally refresh in the background
      _refreshTodosInBackground(page);
      return _todoBox!.values.toList();
    }
    
    try {
      // Reset the hasReachedMax flag if we're starting from page 0
      if (page == 0) {
        _hasReachedMax = false;
      }
      
      // If we've already reached the max, return empty list
      if (_hasReachedMax && page > 0) {
        return [];
      }
      
      final todos = await _apiService.fetchTodos(page: page);
      
      // If we get fewer than expected records or empty list, we've reached the end
      if (todos.isEmpty || todos.length < 20) {
        _hasReachedMax = true;
      }
      
      // Save to Hive
      if (_todoBox != null) {
        // If it's the first page, clear the existing data
        if (page == 0) {
          await _todoBox!.clear();
        }
        
        // Add new todos to the box
        for (var todo in todos) {
          await _todoBox!.put(todo.id, todo);
        }
      }
      
      return todos;
    } catch (e) {
      // If API fails, try to get from Hive
      if (_todoBox != null && _todoBox!.isNotEmpty) {
        return _todoBox!.values.toList();
      }
      
      // If no local data either, rethrow the error
      rethrow;
    }
  }
  
  // Optional method to refresh data in background without blocking UI
  Future<void> _refreshTodosInBackground(int page) async {
    try {
      final todos = await _apiService.fetchTodos(page: page);
      
      if (_todoBox != null) {
        await _todoBox!.clear();
        for (var todo in todos) {
          await _todoBox!.put(todo.id, todo);
        }
      }
    } catch (e) {
      print('Background refresh failed: $e');
    }
  }

  Future<List<TodoDefinition>> fetchTodoDefinitions({bool forceRefresh = false}) async {
    // Try to load from Hive first if not forcing refresh
    if (!forceRefresh && _definitionBox != null && _definitionBox!.isNotEmpty) {
      // We have local data, return it immediately
      // and optionally refresh in the background
      _refreshDefinitionsInBackground();
      return _definitionBox!.values.toList();
    }
    
    try {
      final definitions = await _apiService.fetchTodoDefinitions();
      
      // Save to Hive
      if (_definitionBox != null) {
        await _definitionBox!.clear();
        for (var def in definitions) {
          await _definitionBox!.put(def.type, def);
        }
      }
      
      return definitions;
    } catch (e) {
      // If API fails, try to get from Hive
      if (_definitionBox != null && _definitionBox!.isNotEmpty) {
        return _definitionBox!.values.toList();
      }
      
      // If no local data either, rethrow the error
      rethrow;
    }
  }
  
  // Optional method to refresh definitions in background without blocking UI
  Future<void> _refreshDefinitionsInBackground() async {
    try {
      final definitions = await _apiService.fetchTodoDefinitions();
      
      if (_definitionBox != null) {
        await _definitionBox!.clear();
        for (var def in definitions) {
          await _definitionBox!.put(def.type, def);
        }
      }
    } catch (e) {
      print('Background refresh failed: $e');
    }
  }

  TodoDefinition? getDefinitionForType(String type) {
    if (_definitionBox != null) {
      return _definitionBox!.get(type);
    }
    return null;
  }

  List<Todo> searchTodos(String query) {
    
    final List<Todo> allTodos = _todosForTesting ?? (_todoBox != null ? _todoBox!.values.toList() : []);
    
    if (query.isEmpty) {
      return allTodos;
    }
    
    return allTodos
        .where((todo) => 
            todo.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Map<String, int> getTodoStats({List<Todo>? updatedTodos}) {
    final todos = updatedTodos ?? 
        (_todoBox != null ? _todoBox!.values.toList() : []);
    
    final int completed = todos.where((todo) => todo.completed).length;
    final int remaining = todos.length - completed;
    
    return {
      'completed': completed,
      'remaining': remaining,
      'total': todos.length
    };
  }
  
  Future<bool> updateTodoStatus(String todoId, Todo todo, TodoDefinition? definition) async {
    // Get the action key from definition
    final actionKey = definition?.action ?? 'COMPLETE_TODO';
    
    try {

      final success = await _apiService.updateTodoStatus(todoId, actionKey);
      
      if (success && _todoBox != null) {
        // Update Hive with the updated todo
        final updatedTodo = Todo(
          id: todo.id,
          title: todo.title,
          description: todo.description,
          type: todo.type,
          completed: !todo.completed,
          dueDate: todo.dueDate,
          startTime: todo.startTime,
          finishTime: todo.finishTime,
          phone: todo.phone,
          url: todo.url,
          location: todo.location,
          createdAt: todo.createdAt,
          updatedAt: DateTime.now(),
        );
        
        await _todoBox!.put(todoId, updatedTodo);
      }
      
      return success;
    } catch (e) {
      throw Exception('Error updating todo: $e');
    }
  }
  
  // Clear for testing purposes
  void clearAll() {
    _todoBox?.clear();
    _definitionBox?.clear();
    _hasReachedMax = false;
  }

  // This is only used for testing
void setTodosForTesting(List<Todo> todos) {
  // For testing only
  _todosForTesting = todos;
}
}