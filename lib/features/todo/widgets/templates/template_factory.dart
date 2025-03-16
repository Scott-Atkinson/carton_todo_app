import 'package:carton_todo_app/app/constants/app_text.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:carton_todo_app/features/todo/widgets/templates/checkbox_template.dart';
import 'package:carton_todo_app/features/todo/widgets/templates/deadline_template.dart';
import 'package:carton_todo_app/features/todo/widgets/templates/simple_template.dart';
import 'package:flutter/material.dart';

class TemplateFactory {
  static Widget getTemplateForTodo(Todo todo, TodoDefinition? definition) {
    
    // Default to simple if no definition is available
    if (definition == null) {
      return SimpleTemplate(todo: todo, definition: definition);
    }
    
    // Choose template based on style in definition
    switch (definition.style.toUpperCase()) {
      case AppText.styleSimple:
        return SimpleTemplate(todo: todo, definition: definition);
      case AppText.styleCheckbox:
        return CheckboxTemplate(todo: todo, definition: definition);
      case AppText.styleDeadline:
        return DeadlineTemplate(todo: todo, definition: definition);
      default:
        return SimpleTemplate(todo: todo, definition: definition);
    }
  }
}