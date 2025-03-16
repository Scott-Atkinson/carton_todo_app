import 'package:carton_todo_app/app/constants/app_dimentions.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_bloc.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_event.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:carton_todo_app/features/todo/utils/colour_from_definition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final TodoDefinition? definition;
  final VoidCallback onTap;

  const TodoListItem({
    Key? key,
    required this.todo,
    this.definition,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final color = getColorFromDefinition(definition, todo.completed);

    return Card(
      elevation: AppDimensions.elevationM,
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS, 
        vertical: AppDimensions.paddingXS
      ),
      color: todo.completed ? Colors.grey[200] : withCustomOpacity(color, 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        side: BorderSide(
          color: withCustomOpacity(color, todo.completed ? 0.3 : 0.7),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: () {
          context.read<TodoBloc>().add(ToggleTodoCompletion(todo.id));
        },
        child: Padding(
          padding: AppDimensions.paddingAllM,
          child: Row(
            children: [
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: AppDimensions.fontM,
                        fontWeight: FontWeight.bold,
                        decoration: todo.completed ? TextDecoration.lineThrough : null,
                        color: todo.completed ? Colors.grey[600] : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Type chip
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS, 
                  vertical: AppDimensions.paddingXS
                ),
                decoration: BoxDecoration(
                  color: withCustomOpacity(color, 0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Text(
                  todo.type,
                  style: TextStyle(
                    fontSize: AppDimensions.fontXS,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}