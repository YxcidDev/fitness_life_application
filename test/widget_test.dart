import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_life_application/app/app.dart';

void main() {
  testWidgets('Fitness Life App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FitnessLifeApp());

    expect(find.byType(FitnessLifeApp), findsOneWidget);
  });
}