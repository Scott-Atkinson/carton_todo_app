import 'package:carton_todo_app/features/todo/widgets/todo_detail_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TodoDetailRow Widget Test', () {
    testWidgets('renders correctly with all properties', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoDetailRow(
              icon: Icons.calendar_today,
              title: 'Due Date',
              value: '2023-12-31',
              valueColor: Colors.red,
              smallText: false,
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Due Date'), findsOneWidget);
      expect(find.text('2023-12-31'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      
      // Verify text styling based on smallText parameter
      final titleWidget = tester.widget<Text>(find.text('Due Date'));
      final valueWidget = tester.widget<Text>(find.text('2023-12-31'));
      
      expect(titleWidget.style?.color?.value, Colors.grey[700]?.value);
      expect(valueWidget.style?.color, Colors.red);
    });
    
    testWidgets('applies smallText styling correctly', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoDetailRow(
              icon: Icons.create,
              title: 'Created',
              value: '2023-12-01 10:30',
              smallText: true,
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Created'), findsOneWidget);
      expect(find.text('2023-12-01 10:30'), findsOneWidget);
      
      // Get the icon to verify its size
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.create));
      expect(iconWidget.size, isNot(20)); // Regular size is 20, small is 16
      
      // Verify text styling based on smallText parameter
      final titleWidget = tester.widget<Text>(find.text('Created'));
      final valueWidget = tester.widget<Text>(find.text('2023-12-01 10:30'));
      
      // The fontSize for small text should be smaller
      expect(titleWidget.style?.fontSize, lessThan(14.0));
      expect(valueWidget.style?.fontSize, lessThan(16.0));
    });
  });
}