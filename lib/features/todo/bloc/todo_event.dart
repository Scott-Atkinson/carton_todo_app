import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class FetchTodos extends TodoEvent {
  final int page;
  
  const FetchTodos({this.page = 0});
  
  @override
  List<Object> get props => [page];
}

class FetchTodoDefinitions extends TodoEvent {
  const FetchTodoDefinitions();
}

class SearchTodos extends TodoEvent {
  final String query;
  
  const SearchTodos(this.query);
  
  @override
  List<Object> get props => [query];
}

class LoadMoreTodos extends TodoEvent {
  const LoadMoreTodos();
}

class ToggleTodoCompletion extends TodoEvent {
  final String id;
  
  const ToggleTodoCompletion(this.id);
  
  @override
  List<Object> get props => [id];
}