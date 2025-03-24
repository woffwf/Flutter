import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/main.dart'; 
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/screens/register_screen.dart';
import 'package:my_project/screens/profile_screen.dart';
import 'package:my_project/screens/main_screen.dart';

void main() {
  testWidgets('Test navigation between screens', (WidgetTester tester) async {

    await tester.pumpWidget(MyApp());

    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.tap(find.text('Register'));  
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);
    await tester.tap(find.text('Profile')); 
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
    await tester.tap(find.text('Main')); 
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
  });
}
