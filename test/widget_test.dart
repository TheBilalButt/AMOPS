// =============================================================================
// File: widget_test.dart
// Description: Basic widget test for AMOPS application.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amops/app/app.dart';

void main() {
  testWidgets('AMOPS app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: AmopsApp()),
    );
    // Verify the dashboard title appears
    expect(find.text('Command Dashboard'), findsOneWidget);
  });
}
