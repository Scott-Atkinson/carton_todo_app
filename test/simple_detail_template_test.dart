import 'package:carton_todo_app/app/constants/app_text.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:carton_todo_app/features/todo/widgets/templates/simple_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SimpleDetailTemplate Widget Tests', () {
    late Todo testTodo;
    late TodoDefinition testDefinition;
    
    setUp(() {
      testTodo = Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        type: 'SIMPLE_TODO',
        completed: false,
        dueDate: DateTime.now().add(Duration(days: 1)),
      );
      
      testDefinition = TodoDefinition(
        type: 'SIMPLE_TODO',
        style: 'SIMPLE',
        color: 'BLUE',
        action: 'COMPLETE_TODO',
      );
    });
    
    testWidgets('renders todo information correctly', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimpleTemplate(
              todo: testTodo,
              definition: testDefinition,
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Test Todo'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('SIMPLE_TODO'), findsOneWidget);
      expect(find.text(AppText.descriptionLabel), findsOneWidget);
    });
    
    testWidgets('does not show completion button', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimpleTemplate(
              todo: testTodo,
              definition: testDefinition,
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text(AppText.completeTodo), findsNothing);
    });
  });
}
