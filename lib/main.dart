import 'package:carton_todo_app/app/app.dart';
import 'package:carton_todo_app/core/app_bloc_observer.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_bloc.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_event.dart';
import 'package:carton_todo_app/features/todo/data/todo_repository.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up Bloc observer for debugging
  Bloc.observer = AppBlocObserver();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TodoAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TodoDefinitionAdapter());
  }
  
  // Open Hive boxes
  await Hive.openBox<Todo>('todos');
  await Hive.openBox<TodoDefinition>('todoDefinitions');

  // Load .env file
  await dotenv.load();
  
  // Create repository
  final todoRepository = TodoRepository();
  
  runApp(
    BlocProvider<TodoBloc>(
      create: (context) => TodoBloc(
        repository: todoRepository,
      )
      ..add(FetchTodos())
      ..add(FetchTodoDefinitions()),
      child: TodoApp(),
    ),
  );
}
