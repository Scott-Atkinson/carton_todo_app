import 'dart:ui';
import 'package:carton_todo_app/app/constants/app_dimentions.dart';
import 'package:carton_todo_app/app/constants/app_text.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:carton_todo_app/features/todo/utils/colour_from_definition.dart';
import 'package:flutter/material.dart';

class SimpleTemplate extends StatelessWidget {
  final Todo todo;
  final TodoDefinition? definition;

  const SimpleTemplate({
    super.key,
    required this.todo,
    this.definition,
  });

  @override
  Widget build(BuildContext context) {
    final color = getColorFromDefinition(definition, todo.completed);

    return Card(
      elevation: AppDimensions.elevationL,
      color: withCustomOpacity(color, 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        side: BorderSide(color: color, width: 1),
      ),
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type chip
            Chip(
              backgroundColor: withCustomOpacity(color,0.2),
              label: Text(
                todo.type,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimensions.fontS,
                ),
              ),
            ),
            SizedBox(height: AppDimensions.spacingM),
            
            // Title
            Text(
              todo.title,
              style: TextStyle(
                fontSize: AppDimensions.fontXXL,
                fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}