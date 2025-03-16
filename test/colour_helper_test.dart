import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:carton_todo_app/features/todo/utils/colour_from_definition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColorHelper Tests', () {
    test('getColorFromDefinition should return correct color based on definition', () {
      // Arrange
      final redDefinition = TodoDefinition(
        type: 'URGENT_TODO',
        style: 'CHECKBOX',
        color: 'RED',
        action: 'COMPLETE_TODO',
      );
      
      final greenDefinition = TodoDefinition(
        type: 'NORMAL_TODO',
        style: 'CHECKBOX',
        color: 'GREEN',
        action: 'COMPLETE_TODO',
      );
      
      final blueDefinition = TodoDefinition(
        type: 'SIMPLE_TODO',
        style: 'SIMPLE',
        color: 'BLUE',
        action: 'COMPLETE_TODO',
      );
      
      // Act
      final redColor = getColorFromDefinition(redDefinition, false);
      final greenColor = getColorFromDefinition(greenDefinition, false);
      final blueColor = getColorFromDefinition(blueDefinition, false);
      final nullColor = getColorFromDefinition(null, false);
      
      // Assert
      expect(redColor, Colors.red);
      expect(greenColor, Colors.green);
      expect(blueColor, Colors.blue);
      expect(nullColor, Colors.blue); // Default color when definition is null
    });
  });
}
