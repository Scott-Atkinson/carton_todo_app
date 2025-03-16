import 'package:carton_todo_app/app/constants/app_text.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_event.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_state.dart';
import 'package:carton_todo_app/features/todo/data/todo_repository.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _repository;

  Map<String, TodoDefinition> _definitions = {};
  Map<String, TodoDefinition> get definitions => _definitions;
  
  List<Todo> _allTodos = []; 
  List<Todo> get allTodos => _allTodos;

  bool _hasReachedMax = false;
  bool get hasReachedMax => _hasReachedMax;

  int _currentPage = 0;
  int get currentPage => _currentPage;


  TodoBloc({required TodoRepository repository}) 
      : _repository = repository,
        super(TodoInitial()) {
    on<FetchTodos>(_onFetchTodos);
    on<FetchTodoDefinitions>(_onFetchTodoDefinitions);
    on<SearchTodos>(_onSearchTodos);
    on<LoadMoreTodos>(_onLoadMoreTodos);
    on<ToggleTodoCompletion>(_onToggleTodoCompletion);
  }

  Future<void> _onFetchTodoDefinitions(
    FetchTodoDefinitions event, 
    Emitter<TodoState> emit
  ) async {
    try {
      final definitions = await _repository.fetchTodoDefinitions();
      
      // Create a map for easier lookup and store at class level
      _definitions = {
        for (var def in definitions) def.type: def
      };
      
      // If we already have todos loaded, update the state
      if (state is TodoLoaded) {
        final currentState = state as TodoLoaded;
        emit(currentState.copyWith(definitions: _definitions));
      }

    } catch (e) {
      print('Error loading definitions: $e');
    }
  }

  Future<void> _onFetchTodos(
    FetchTodos event, 
    Emitter<TodoState> emit
  ) async {
    try {
      // For initial load or explicit refresh (page 0)
      if (event.page == 0) {
        // Show loading state
        emit(const TodoLoading());
        
        // Fetch todos from repository
        final todos = await _repository.fetchTodos(page: event.page);
        
        _allTodos = todos;
        _currentPage = 0;
        _hasReachedMax = todos.isEmpty;
        
        final stats = _repository.getTodoStats(updatedTodos: _allTodos);
        
        // Load definitions if needed
        if (_definitions.isEmpty) {
          try {
            final definitions = await _repository.fetchTodoDefinitions();
            _definitions = {
              for (var def in definitions) def.type: def
            };
          } catch (e) {
            print('Error loading definitions during todos fetch: $e');
          }
        }
        
        emit(TodoLoaded(
          todos: _allTodos,
          definitions: _definitions,
          stats: stats,
          hasReachedMax: _hasReachedMax,
          currentPage: _currentPage,
          isLoadingMore: false,
        ));
      } 

      // For pagination (page > 0)
      else if (state is TodoLoaded) {
        final currentState = state as TodoLoaded;

        emit(currentState.copyWith(isLoadingMore: true));
        
        final newTodos = await _repository.fetchTodos(page: event.page);
        
        _hasReachedMax = newTodos.isEmpty;
        
        if (newTodos.isNotEmpty) {
          _allTodos.addAll(newTodos);
          _currentPage = event.page;
        }
        
        final stats = _repository.getTodoStats(updatedTodos: _allTodos);
        
        emit(TodoLoaded(
          todos: _allTodos,
          definitions: _definitions,
          stats: stats,
          hasReachedMax: _hasReachedMax,
          currentPage: _currentPage,
          isLoadingMore: false,
        ));
      }
    } catch (e) {
     
      String errorMessage;
      if (e.toString().contains('SocketException') || 
          e.toString().contains('ConnectionRefused')) {
        errorMessage = AppText.connectionError;
      } else if (e.toString().contains('500') || 
               e.toString().contains('503')) {
        errorMessage = AppText.serverError;
      } else {
        errorMessage = '${AppText.error} ${e.toString()}';
      }
      
      emit(TodoError(errorMessage));
    }
  }

  Future<void> _onSearchTodos(
    SearchTodos event, 
    Emitter<TodoState> emit
  ) async {
    if (state is TodoLoaded) {

      emit(const TodoLoading(isFirstLoad: false));
      
      List<Todo> filteredTodos;
      if (event.query.isEmpty) {
        filteredTodos = _allTodos;
      } else {
        filteredTodos = _allTodos.where((todo) => 
          todo.title.toLowerCase().contains(event.query.toLowerCase())
        ).toList();
      }
     
      final stats = {
        'completed': filteredTodos.where((todo) => todo.completed).length,
        'remaining': filteredTodos.length - filteredTodos.where((todo) => todo.completed).length,
        'total': filteredTodos.length
      };
      
      emit(TodoLoaded(
        todos: filteredTodos,
        definitions: _definitions,
        stats: stats,
        hasReachedMax: true, 
        currentPage: _currentPage,
        isLoadingMore: false,
      ));
    }
  }

  Future<void> _onLoadMoreTodos(
    LoadMoreTodos event, 
    Emitter<TodoState> emit
  ) async {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      
      if (!_hasReachedMax && !currentState.isLoadingMore) {
        add(FetchTodos(page: _currentPage + 1));
      }
    }
  }

  Future<void> _onToggleTodoCompletion(
    ToggleTodoCompletion event, 
    Emitter<TodoState> emit
  ) async {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      try {
        // Find the todo to update
        int todoIndex = _allTodos.indexWhere((todo) => todo.id == event.id);
        if (todoIndex == -1) {
          throw Exception('Todo not found');
        }
        
        Todo todoToUpdate = _allTodos[todoIndex];
        final definition = _definitions[todoToUpdate.type] ?? 
          TodoDefinition(
            type: todoToUpdate.type,
            style: 'CHECKBOX',
            color: todoToUpdate.type.contains('URGENT') ? 'RED' : 'BLUE',
            action: 'COMPLETE_TODO'
          );
        
        // Create updated todo
        Todo updatedTodo = Todo(
          id: todoToUpdate.id,
          title: todoToUpdate.title,
          description: todoToUpdate.description,
          type: todoToUpdate.type,  // Keep the original type
          completed: !todoToUpdate.completed,
          dueDate: todoToUpdate.dueDate,
          startTime: todoToUpdate.startTime,
          finishTime: todoToUpdate.finishTime,
          phone: todoToUpdate.phone,
          url: todoToUpdate.url,
          location: todoToUpdate.location,
          createdAt: todoToUpdate.createdAt,
          updatedAt: DateTime.now(),
        );
        
        // Optimistic update - update UI immediately
        // Update the todo in our in-memory list
        _allTodos[todoIndex] = updatedTodo;
        
        // If we're in a filtered view (like search), create new filtered list
        List<Todo> viewTodos;
        if (currentState.todos.length != _allTodos.length) {
          // We're in a filtered view
          viewTodos = currentState.todos.map((todo) {
            if (todo.id == event.id) {
              return updatedTodo;
            }
            return todo;
          }).toList();
        } else {
          // We're showing all todos
          viewTodos = _allTodos;
        }
        
        // Calculate updated statistics
        final updatedStats = _repository.getTodoStats(updatedTodos: viewTodos);
        
        // Emit optimistically updated state
        emit(TodoLoaded(
          todos: viewTodos,
          definitions: _definitions,
          stats: updatedStats,
          hasReachedMax: _hasReachedMax,
          currentPage: _currentPage,
          isLoadingMore: false,
        ));
        
        // Perform actual API update
        final success = await _repository.updateTodoStatus(event.id, todoToUpdate, definition);
        
        // If the API update failed, revert the optimistic update
        if (!success) {
          // Revert the change in our in-memory list
          _allTodos[todoIndex] = todoToUpdate;
          
          // Create new view list if needed
          if (currentState.todos.length != _allTodos.length) {
            viewTodos = currentState.todos.map((todo) {
              if (todo.id == event.id) {
                return todoToUpdate;  // Revert to original
              }
              return todo;
            }).toList();
          } else {
            viewTodos = _allTodos;
          }
          
          // Revert the state
          emit(TodoLoaded(
            todos: viewTodos,
            definitions: _definitions,
            stats: _repository.getTodoStats(updatedTodos: viewTodos),
            hasReachedMax: _hasReachedMax,
            currentPage: _currentPage,
            isLoadingMore: false,
          ));
          
          // Emit error
          emit(TodoError(AppText.todoUpdateError));
        }
        
      } catch (e) {

        String errorMessage;
       
        if (e.toString().contains('SocketException') || 
            e.toString().contains('ConnectionRefused')) {
          errorMessage = AppText.connectionError;
        } else {
          errorMessage = AppText.todoUpdateError;
        }

        emit(TodoError(errorMessage));
      }
    }
  }
  

}