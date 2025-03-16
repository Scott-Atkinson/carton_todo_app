import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:equatable/equatable.dart';

abstract class TodoState extends Equatable {
  const TodoState();
  
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {
  final bool isFirstLoad;
  
  const TodoLoading({this.isFirstLoad = true});
  
  @override
  List<Object> get props => [isFirstLoad];
}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  final Map<String, TodoDefinition> definitions;
  final Map<String, int> stats;
  final bool hasReachedMax;
  final int currentPage;
  final bool isLoadingMore;
  
  const TodoLoaded({
    required this.todos, 
    required this.definitions,
    required this.stats,
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.isLoadingMore = false,
  });
  
  TodoLoaded copyWith({
    List<Todo>? todos,
    Map<String, TodoDefinition>? definitions,
    Map<String, int>? stats,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return TodoLoaded(
      todos: todos ?? this.todos,
      definitions: definitions ?? this.definitions,
      stats: stats ?? this.stats,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
  
  @override
  List<Object> get props => [
    todos, 
    definitions, 
    stats, 
    hasReachedMax, 
    currentPage, 
    isLoadingMore
  ];
}

class TodoError extends TodoState {
  final String message;
  
  const TodoError(this.message);
  
  @override
  List<Object> get props => [message];
}