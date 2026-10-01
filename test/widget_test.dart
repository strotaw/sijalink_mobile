import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijalink_mobile/main.dart';

void main() {
  testWidgets('Teknisi shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SijaLinkApp());
    await tester.pumpAndSettle();
    expect(find.text('SijaLink Teknisi'), findsOneWidget);
    expect(find.text('Kehadiran Hari Ini'), findsOneWidget);
    expect(find.text('SPK Aktif'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
