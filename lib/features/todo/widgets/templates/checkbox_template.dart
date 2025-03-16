import 'package:carton_todo_app/app/constants/app_dimentions.dart';
import 'package:carton_todo_app/app/constants/app_text.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_bloc.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_event.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:carton_todo_app/features/todo/utils/colour_from_definition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckboxTemplate extends StatelessWidget {
  final Todo todo;
  final TodoDefinition? definition;

  const CheckboxTemplate({
    super.key,
    required this.todo,
    this.definition,
  });

  @override
  Widget build(BuildContext context) {
    final color = getColorFromDefinition(definition, todo.completed);

    return Card(
      elevation: AppDimensions.elevationL,
      color: todo.completed ? Colors.grey[200] : withCustomOpacity(color, 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        side: BorderSide(color: color, width: 1),
      ),
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  backgroundColor: withCustomOpacity(color, 0.2),
                  label: Text(
                    todo.type,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontS,
                    ),
                  ),
                ),
                
                // Status indicator
                Chip(
                  backgroundColor: todo.completed ? withCustomOpacity(Colors.green, 0.2) : withCustomOpacity(Colors.grey, 0.2),
                  label: Text(
                    todo.completed ? AppText.completedStatus : AppText.pendingStatus,
                    style: TextStyle(
                      color: todo.completed ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontS,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacingM),
            
            // Title
            Text(
              todo.title,
              style: TextStyle(
                fontSize: AppDimensions.fontXXL,
                fontWeight: FontWeight.bold,
                decoration: todo.completed ? TextDecoration.lineThrough : null,
              ),
              softWrap: true,
            ),
            SizedBox(height: AppDimensions.spacingL),
            
            // Description
            Text(
              AppText.descriptionLabel,
              style: TextStyle(
                fontSize: AppDimensions.fontM,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: AppDimensions.spacingS),
            Text(
              todo.description,
              style: TextStyle(fontSize: AppDimensions.fontM),
              softWrap: true,
            ),
            SizedBox(height: AppDimensions.spacingXL),
            
            // Complete button (only shown if not completed)
            if (!todo.completed)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TodoBloc>().add(ToggleTodoCompletion(todo.id));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingXL,
                      vertical: AppDimensions.paddingM,
                    ),
                  ),
                  child: Text(AppText.completeTodo),
                ),
              ),
          ],
        ),
      ),
    );
  }
}