import 'package:flutter_test/flutter_test.dart';

import 'package:fixmate/main.dart';

void main() {
  testWidgets('FixMate app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FixMateApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('FixMate'), findsOneWidget);
    expect(find.text('ابدأ'), findsOneWidget);
  });
}
