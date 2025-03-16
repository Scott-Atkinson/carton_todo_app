
import 'package:carton_todo_app/app/constants/app_text.dart';
import 'package:carton_todo_app/features/todo/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppText.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Center(
        child: TodoListScreen(),
      ),
    );
  }
}