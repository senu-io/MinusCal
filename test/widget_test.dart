import 'package:flutter_test/flutter_test.dart';
import 'package:minuscal/main.dart';
import 'package:minuscal/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('MinusCal smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = StorageService();
    await storageService.init();

    await tester.pumpWidget(MinusCalApp(storageService: storageService));
    await tester.pumpAndSettle();

    expect(find.text('Kitchen'), findsWidgets);
  });
}
