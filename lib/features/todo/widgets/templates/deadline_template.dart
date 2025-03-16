import 'package:carton_todo_app/app/constants/app_dimentions.dart';
import 'package:carton_todo_app/app/constants/app_text.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_bloc.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_event.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:carton_todo_app/features/todo/utils/date_helper.dart';
import 'package:carton_todo_app/features/todo/utils/colour_from_definition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeadlineTemplate extends StatelessWidget {
  final Todo todo;
  final TodoDefinition? definition;

  const DeadlineTemplate({
    super.key,
    required this.todo,
    this.definition,
  });

  @override
  Widget build(BuildContext context) {
    final color = getColorFromDefinition(definition, todo.completed);
    final isOverdue = todo.dueDate != null && DateHelper.isOverdue(todo.dueDate) && !todo.completed;
    
    // Determine background color, text and button text based on status
    Color backgroundColor;
    String statusText;
    String buttonText;
    bool showButton;
    
    if (todo.completed) {
      // Completed
      backgroundColor = Colors.grey[200]!;
      statusText = AppText.completedStatus;
      buttonText = "";
      showButton = false;
    } else if (isOverdue) {
      // Overdue
      backgroundColor = Colors.red[50]!;
      statusText = AppText.overdue;
      buttonText = AppText.lateComplete;
      showButton = true;
    } else {
      // Before due date and not complete
      backgroundColor = Colors.white;
      statusText = todo.dueDate != null 
          ? DateHelper.formatDate(todo.dueDate!)
          : AppText.pendingStatus;
      buttonText = AppText.completeTodo;
      showButton = true;
    }

    return Card(
      elevation: AppDimensions.elevationL,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        side: BorderSide(
          color: isOverdue 
              ? Colors.red 
              : (todo.completed ? Colors.grey : color),
          width: 1,
        ),
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
                  backgroundColor: color.withOpacity(0.2),
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
                  backgroundColor: isOverdue 
                      ? Colors.red.withOpacity(0.2) 
                      : (todo.completed ? Colors.green.withOpacity(0.2) : Colors.blue.withOpacity(0.2)),
                  label: Text(
                    statusText,
                    style: TextStyle(
                      color: isOverdue 
                          ? Colors.red 
                          : (todo.completed ? Colors.green : Colors.blue),
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
            SizedBox(height: AppDimensions.spacingL),
            
            // Due date info
            if (todo.dueDate != null) ...[
              Row(
                children: [
                  Icon(
                    isOverdue ? Icons.warning : Icons.calendar_today,
                    color: isOverdue ? Colors.red : Colors.grey[700],
                    size: AppDimensions.iconM,
                  ),
                  SizedBox(width: AppDimensions.spacingS),
                  Text(
                    isOverdue
                        ? AppText.dueDateWas + DateHelper.formatDate(todo.dueDate!)
                        : AppText.dueDateIs + DateHelper.formatDate(todo.dueDate!),
                    style: TextStyle(
                      fontSize: AppDimensions.fontM,
                      color: isOverdue ? Colors.red : Colors.grey[700],
                      fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.spacingXL),
            ],
            
            // Complete button (only shown if conditions met)
            if (showButton)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TodoBloc>().add(ToggleTodoCompletion(todo.id));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOverdue ? Colors.red : color,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingXL,
                      vertical: AppDimensions.paddingM,
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ),
          ],
        ),
      ),
    );
  }
}