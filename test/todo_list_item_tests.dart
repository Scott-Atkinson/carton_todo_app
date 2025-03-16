import 'package:carton_todo_app/features/todo/bloc/todo_bloc.dart';
import 'package:carton_todo_app/features/todo/bloc/todo_state.dart';
import 'package:carton_todo_app/features/todo/model/todo.dart';
import 'package:carton_todo_app/features/todo/model/todo_definition.dart';
import 'package:carton_todo_app/features/todo/widgets/todo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoBloc extends Mock implements TodoBloc {}

void main() {
  group('TodoListItem Widget Tests', () {
    late MockTodoBloc mockTodoBloc;
    late Todo testTodo;
    late TodoDefinition testDefinition;
    
    setUp(() {
      mockTodoBloc = MockTodoBloc();
      
      testTodo = Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        type: 'URGENT_TODO',
        completed: false,
        dueDate: DateTime.now().add(Duration(days: 1)),
      );
      
      testDefinition = TodoDefinition(
        type: 'URGENT_TODO',
        style: 'CHECKBOX',
        color: 'RED',
        action: 'COMPLETE_TODO',
      );
      
      when(() => mockTodoBloc.state).thenReturn(TodoInitial());
    });
    
    testWidgets('renders correctly with provided todo', (WidgetTester tester) async {
      // Arrange
      bool onTapCalled = false;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TodoBloc>.value(
            value: mockTodoBloc,
            child: Scaffold(
              body: TodoListItem(
                todo: testTodo,
                definition: testDefinition,
                onTap: () {
                  onTapCalled = true;
                },
              ),
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Test Todo'), findsOneWidget);
      expect(find.text('URGENT_TODO'), findsOneWidget);
      
      // Test onTap callback
      await tester.tap(find.byType(TodoListItem));
      expect(onTapCalled, true);
    });
    
    testWidgets('displays completed todo with strikethrough text', (WidgetTester tester) async {
      // Arrange
      final completedTodo = Todo(
        id: '1',
        title: 'Completed Todo',
        description: 'Test Description',
        type: 'URGENT_TODO',
        completed: true,
        dueDate: DateTime.now().add(Duration(days: 1)),
      );
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TodoBloc>.value(
            value: mockTodoBloc,
            child: Scaffold(
              body: TodoListItem(
                todo: completedTodo,
                definition: testDefinition,
                onTap: () {},
              ),
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Completed Todo'), findsOneWidget);
      
      // Find the Text widget and check if it has strikethrough decoration
      final textWidget = tester.widget<Text>(
        find.text('Completed Todo')
      );
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });
  });
}