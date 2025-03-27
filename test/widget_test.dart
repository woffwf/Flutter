import 'package:flutter_test/flutter_test.dart';
import 'package:mob/main.dart';
import 'package:mob/screen/login_screen.dart';
import 'package:mob/screen/register_screen.dart';
import 'package:mob/screen/profile_screen.dart';
import 'package:mob/screen/main_screen.dart';

void main() {
  testWidgets('Test navigation between screens', (WidgetTester tester) async {

    await tester.pumpWidget(const MyApp());

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


