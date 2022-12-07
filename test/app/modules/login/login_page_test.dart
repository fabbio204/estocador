import 'package:estocador/app/modules/login/login_page.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('LoginPage', () {
    testWidgets('has a title and message', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const LoginPage(title: 'T')));
      final titleFinder = find.text('T');
      expect(titleFinder, findsOneWidget);
    });
  });
}