import 'package:carton_todo_app/app/constants/app_text.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_bloc.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_event.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_state.dart';
import 'package:carton_todo_app/features/todo/screens/todo_detail_screen.dart';
import 'package:carton_todo_app/features/todo/widgets/todo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearching = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_isNearBottomEdge()) {
      final state = context.read<TodoBloc>().state;
    
      if (state is TodoLoaded && !state.hasReachedMax && !state.isLoadingMore) {
        context.read<TodoBloc>().add(LoadMoreTodos());
      }
    }
  }
  
  bool _isNearBottomEdge() {
    if (!_scrollController.hasClients) return false;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.todoListTitle),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching && _searchController.text.isNotEmpty) {
                  _searchController.clear();
                  context.read<TodoBloc>().add(FetchTodos());
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppText.searchTodos,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<TodoBloc>().add(FetchTodos());
                        },
                      )
                    : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (query) {
                  if (query.isEmpty && _searchController.text.isNotEmpty) {
                    context.read<TodoBloc>().add(FetchTodos());
                  } else {
                    context.read<TodoBloc>().add(SearchTodos(query));
                  }
                },
              ),
            ),
          
          // Todo stats bar
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoLoaded) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${AppText.total}${state.stats['total'] ?? 0}', 
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                          SizedBox(width: 4),
                          Text('${state.stats['completed'] ?? 0}'),
                          SizedBox(width: 12),
                          Icon(Icons.watch_later, color: Colors.orange, size: 16),
                          SizedBox(width: 4),
                          Text('${state.stats['remaining'] ?? 0}'),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
          
          // Todo list
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoInitial || (state is TodoLoading && state.isFirstLoad)) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TodoLoaded) {
                  if (state.todos.isEmpty) {
                    return Center(
                      child: Text(AppText.noTodosFound),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<TodoBloc>().add(FetchTodos());
                      return;
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.todos.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.todos.length) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        
                        final todo = state.todos[index];
                        final definition = state.definitions[todo.type];
                        
                        return TodoListItem(
                          todo: todo,
                          definition: definition,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TodoDetailScreen(
                                  todo: todo,
                                  definition: definition,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else if (state is TodoError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${AppText.error}${state.message}',
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TodoBloc>().add(FetchTodos());
                          },
                          child: Text(AppText.tryAgain),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TodoBloc>().add(FetchTodos());
        },
        tooltip: AppText.refresh,
        child: Icon(Icons.refresh),
      ),
    );
  }
}