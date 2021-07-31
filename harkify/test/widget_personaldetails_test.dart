import 'package:Harkify/textnoteservice.dart';
import 'package:Harkify/personalDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

/// Conduct unit tests of the ViewNotes widget
void main() {
  /// The file system to use for all I/O operations without saving real files
  FileSystem fileSystem = MemoryFileSystem();

  /// Some preparatory steps to take before executing a test
  prepForTests() {
    // Reinitialize file system and service so we're starting from a blank slate
    fileSystem = MemoryFileSystem();
    TextNoteService.fileSystem = fileSystem;
  }

  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('test view personal details screen', (WidgetTester tester) async {
    prepForTests();
    // Build our app and trigger a frame.
    await tester
        .pumpWidget(createWidgetForTesting(child: new ViewPersonalDetails()));

    // Should see the progress indicator while personal details load
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    // Application should show "View Personal Details" as title
    expect(find.text("View Personal Details"), findsOneWidget);

    // Application should have one menu icon button
    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Application should have one search bar icon button
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Application should show that no text notes have been saved
    expect(
        find.text(
            "Uh-oh! It looks like you don't have any personal details saved. Try saving some details first and come back here."),
        findsOneWidget);

    // Application should have one "+" icon button
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
