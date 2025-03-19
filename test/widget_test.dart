import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:my_project/main.dart'; 

void main() {
  testWidgets('HomePage basic interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TaskProvider(),
        child: const MaterialApp(home: HomePage()),
      ),
    );

    expect(find.text('Поки що немає завдань!'), findsOneWidget);

    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    await tester.enterText(textFieldFinder, 'Перше завдання');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Перше завдання'), findsOneWidget);

    final checkButtonFinder = find.byIcon(Icons.radio_button_unchecked);
    expect(checkButtonFinder, findsOneWidget);

    await tester.tap(checkButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    final taskItemFinder = find.text('Перше завдання');
    expect(taskItemFinder, findsOneWidget);

    await tester.drag(taskItemFinder, const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Поки що немає завдань!'), findsOneWidget);
  });
}
