// Smoke test for the app shell: it starts on the home page with an empty
// workout list and exposes the add-workout action.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workouts_timer/main.dart';

void main() {
  testWidgets('home page starts empty with an add action',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    expect(find.text('Workouts'), findsOneWidget);
    expect(find.text('No workouts yet. Add one to get started!'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
