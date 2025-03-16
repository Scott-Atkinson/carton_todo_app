import 'package:carton_todo_app/app/constants/app_dimentions.dart';
import 'package:carton_todo_app/app/constants/app_text.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:carton_todo_app/features/todo/utils/date_helper.dart';
import 'package:carton_todo_app/features/todo/utils/colour_from_definition.dart';
import 'package:carton_todo_app/features/todo/widgets/templates/template_factory.dart';
import 'package:carton_todo_app/features/todo/widgets/todo_detail_row.dart';
import 'package:flutter/material.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;
  final TodoDefinition? definition;

  const TodoDetailScreen({
    super.key,
    required this.todo,
    this.definition,
  });

  @override
  Widget build(BuildContext context) {
    final color = getColorFromDefinition(definition, todo.completed);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.todoDetailsTitle),
        backgroundColor: withCustomOpacity(color, 0.7),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.paddingAllL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Use the template factory to get the appropriate template
            TemplateFactory.getTemplateForTodo(todo, definition),
            
            SizedBox(height: AppDimensions.spacingXL),
            
            // Additional metadata section (always visible regardless of template)
            Card(
              elevation: AppDimensions.elevationM,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Padding(
                padding: AppDimensions.paddingAllL,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppText.additionalDetails,
                      style: TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacingM),
                    
                    // Show any other fields that might be available
                    if (todo.location != null && todo.location!.isNotEmpty) ...[
                      TodoDetailRow(
                       icon: Icons.location_on, 
                        title: AppText.locationLabel, 
                        value: todo.location!
                      ),
                      SizedBox(height: AppDimensions.spacingM),
                    ],
                    
                    if (todo.url != null && todo.url!.isNotEmpty) ...[
                      TodoDetailRow(
                       icon: Icons.link, 
                        title: AppText.urlLabel, 
                        value: todo.url!
                      ),
                      SizedBox(height: AppDimensions.spacingM),
                    ],
                    
                    if (todo.phone != null && todo.phone!.isNotEmpty) ...[
                      TodoDetailRow(
                        icon: Icons.phone, 
                        title: AppText.phoneLabel, 
                        value: todo.phone!
                      ),
                      SizedBox(height: AppDimensions.spacingM),
                    ],
                    
                    Divider(),
                    SizedBox(height: AppDimensions.spacingS),
                    
                    if (todo.createdAt != null) ...[
                      TodoDetailRow(
                        icon: Icons.create, 
                        title: AppText.createdLabel, 
                        value: DateHelper.formatDateTime(todo.createdAt!),
                        smallText: true
                      ),
                      SizedBox(height: AppDimensions.spacingS),
                    ],
                    
                    if (todo.updatedAt != null) ...[
                      TodoDetailRow(
                        icon: Icons.update, 
                        title: AppText.updatedLabel, 
                        value: DateHelper.formatDateTime(todo.updatedAt!),
                        smallText: true
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
