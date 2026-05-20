// Import Flutter material package for UI widgets
import 'package:flutter/material.dart';

// Import Flutter testing framework
import 'package:flutter_test/flutter_test.dart';

// Import the screens being tested
import 'package:celestia_app/screens/home_screen.dart';
import 'package:celestia_app/screens/search_screen.dart';

void main() {
  // =========================
  // WIDGET TESTING OVERVIEW
  // =========================
  /*
    Widget tests are used to verify:
    - UI rendering (widgets appear correctly)
    - User interactions (typing, tapping)
    - Navigation elements
    - Text and layout correctness

    These tests do NOT call real APIs.
    They only test the UI behavior in isolation.
  */

  // TEST 1: HOME SCREEN LOADS
  testWidgets('Home screen loads without waiting for animations', (
    tester,
  ) async {
    // Build the HomeScreen inside a MaterialApp
    // MaterialApp is required to provide theme, navigation, etc.
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Pump once to render initial frame
    // We avoid pumpAndSettle because HomeScreen has infinite animation
    await tester.pump();

    // Verify that the main title appears on screen
    expect(find.text('Celestia'), findsWidgets);
  });

  // TEST 2: HOME SCREEN TILES
  testWidgets('Home tiles exist', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.pump();

    // Check that all navigation tiles are visible
    expect(find.text('Picture of the Day'), findsOneWidget);
    expect(find.text('Missions & News'), findsOneWidget);
    expect(find.text('Latest Images'), findsOneWidget);
    expect(find.text('Asteroid Tracker'), findsOneWidget);
  });

  // TEST 3: SEARCH SCREEN LOADS
  testWidgets('Search screen loads UI', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchScreen()));

    // Verify app bar title is displayed
    expect(find.text('Search NASA Images'), findsOneWidget);
  });

  // TEST 4: TEXT INPUT WORKS
  testWidgets('Search text input works', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchScreen()));

    // Simulate user typing into the TextField
    await tester.enterText(find.byType(TextField), 'Mars');

    // Verify that the entered text is present in the widget tree
    expect(find.text('Mars'), findsOneWidget);
  });

  // TEST 5: DEFAULT UI MESSAGE
  testWidgets('Default search message appears', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchScreen()));

    // Check that the default placeholder message is shown
    expect(find.text('Search to see NASA images'), findsOneWidget);
  });
}
