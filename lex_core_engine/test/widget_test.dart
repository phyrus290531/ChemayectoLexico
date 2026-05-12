import 'package:flutter_test/flutter_test.dart';
import 'package:lex_core_engine/main.dart';

void main() {
  testWidgets('LEX-CORE ENGINE app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LexCoreEngineApp());
    expect(find.text('LEX-CORE ENGINE'), findsOneWidget);
  });
}
