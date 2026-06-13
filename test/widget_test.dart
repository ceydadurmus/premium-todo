import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/main.dart';

void main() {
  testWidgets('Uygulama baslatma testi', (WidgetTester tester) async {
    // Uygulamayı başlat
    await tester.pumpWidget(const MyApp());

    // Ana ekrandaki 'Yapılacaklar 👋' başlığının varlığını doğrula
    expect(find.text('Yapılacaklar 👋'), findsOneWidget);
  });
}
