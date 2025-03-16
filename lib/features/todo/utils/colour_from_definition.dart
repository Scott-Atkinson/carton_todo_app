import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:flutter/material.dart';

// Helper function to replace withOpacity with proper implementation
Color withCustomOpacity(Color color, double opacity) {
  return Color.fromRGBO(
    color.red, 
    color.green, 
    color.blue, 
    opacity
  );
}

Color getColorFromDefinition(TodoDefinition? definition, bool completed) {
  // If definition is null, return default color
  if (definition == null) {
    return Colors.blue;
  }
  
  Color baseColor;
  
  switch (definition.color.toUpperCase()) {
    case 'RED':
      baseColor = Colors.red;
      break;
    case 'GREEN':
      baseColor = Colors.green;
      break;
    case 'BLUE':
      baseColor = Colors.blue;
      break;
    case 'YELLOW':
      baseColor = Colors.amber;
      break;
    case 'PURPLE':
      baseColor = Colors.purple;
      break;
    case 'ORANGE':
      baseColor = Colors.orange;
      break;
    case 'PINK':
      baseColor = Colors.pink;
      break;
    case 'TEAL':
      baseColor = Colors.teal;
      break;
    case 'CYAN':
      baseColor = Colors.cyan;
      break;
    case 'BROWN':
      baseColor = Colors.brown;
      break;
    case 'GREY':
    case 'GRAY':
      baseColor = Colors.grey;
      break;
    default:
      baseColor = Colors.blue;
      break;
  }
  
  // We'll handle the opacity and visual treatment in the UI layer
  // Just return the base color here
  return baseColor;
}