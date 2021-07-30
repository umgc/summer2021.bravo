import 'package:Harkify/basemenudrawer.dart';
import 'package:Harkify/main.dart';
import 'package:Harkify/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  testWidgets('test mic prompt', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Application should prompt the user to start recording
    expect(find.text('Press the mic button to start'), findsOneWidget);
  });

  testWidgets('test menu drawer contents', (WidgetTester tester) async {
    // Create a Material app to hold the drawer we're going to test
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      key: scaffoldKey,
      // The drawer we're going to test
      drawer: BaseMenuDrawer(),
    )));

    scaffoldKey.currentState!.openDrawer();
    await tester.pump();

    // Drawer should contain View Notes option
    expect(find.text("View Notes"), findsOneWidget);

    // Drawer should contain Settings option
    expect(find.text("Settings"), findsOneWidget);

    // Drawer should contain Help option
    expect(find.text("Help"), findsOneWidget);
  });

  testWidgets('test settings content', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      key: scaffoldKey,
      body: settingsPage(),
    )));

    // Settings should contain an option for changing purge notes time
    expect(find.text("Number of Days to Keep Text Notes"), findsOneWidget);

    // Settings should contain an option for changing duration before stopping recording
    expect(find.text("Number of Seconds of Silence Before Stopping Recording"),
        findsOneWidget);
  });

  testWidgets('', (WidgetTester tester) async {});
}
