import 'package:Harkify/basemenudrawer.dart';
import 'package:Harkify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('test mic prompt', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Application should prompt the user to start recording
    expect(find.text('Press the mic button to start'), findsOneWidget);

  });

  testWidgets('test open menu', (WidgetTester tester) async {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        drawer: BaseMenuDrawer(),
      )
    ));

    scaffoldKey.currentState!.openDrawer();
    await tester.pump();

    // Drawer should contain View Notes option
    expect(find.text("View Notes"), findsOneWidget);

    // Drawer should contain Settings option
    expect(find.text("Settings"), findsOneWidget);
  });

}
