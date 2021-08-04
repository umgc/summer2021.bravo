import 'package:Harkify/textnoteservice.dart';
import 'package:Harkify/notedetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';

/// Conduct unit tests of the NoteDetails widget
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

  testWidgets('test note details screen', (WidgetTester tester) async {
    prepForTests();
    // Build our app and trigger a frame.
    await tester.pumpWidget(createWidgetForTesting(child: new NoteDetails()));

    // Should see the progress indicator while text notes load
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    // Application should show "Notes" as title
    expect(find.text("Notes"), findsOneWidget);

    // Application should NOT have a menu icon button
    expect(find.byIcon(Icons.menu), findsNothing);

    // Application should have one edit button
    expect(find.byIcon(Icons.edit), findsOneWidget);

    // Application should have one delete button
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}
