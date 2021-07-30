import 'package:Harkify/help.dart';
import 'package:Harkify/personalDetails.dart';
import 'package:Harkify/recordnote.dart';
import 'package:Harkify/savenote.dart';
import 'package:Harkify/settings.dart';
import 'package:Harkify/viewnotes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:Harkify/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("end-to-end test", (WidgetTester tester) async {
    // await Process.run('adb', [
    //   'shell',
    //   'pm',
    //   'grant',
    //   'edu.umgc.harkify', // replace with your app id
    //   'android.permission.RECORD_AUDIO'
    // ]);

    app.main();

    // Trigger a frame.
    await tester.pumpAndSettle();

    // Application should prompt the user to start recording
    expect(find.text('Press the mic button to start'), findsOneWidget);

    recordNoteScaffoldKey.currentState!.openEndDrawer();
    await tester.pumpAndSettle();

    // Drawer should contain Settings option
    Finder settingsFinder = find.text("Settings");
    expect(settingsFinder, findsOneWidget);

    await tester.tap(settingsFinder);
    await tester.pumpAndSettle();

    // Settings should contain an option for changing purge notes time
    expect(find.text("Number of Days to Keep Text Notes"), findsOneWidget);

    // Settings should contain an option for changing duration before stopping recording
    expect(find.text("Number of Seconds of Silence Before Stopping Recording"),
        findsOneWidget);

    settingsScaffoldKey.currentState!.openEndDrawer();
    await tester.pumpAndSettle();

    // Drawer should contain View Notes option
    Finder viewNotesFinder = find.text("View Notes");
    expect(viewNotesFinder, findsOneWidget);

    await tester.tap(viewNotesFinder);
    await tester.pumpAndSettle();

    viewNotesScaffoldKey.currentState!.openEndDrawer();
    await tester.pumpAndSettle();

    Finder personalDetailsFinder = find.text("My Details");
    expect(personalDetailsFinder, findsOneWidget);

    await tester.tap(personalDetailsFinder);
    await tester.pumpAndSettle();

    personalDetailsScaffoldKey.currentState!.openEndDrawer();
    await tester.pumpAndSettle();

    Finder saveNoteFinder = find.text("Save Note");
    expect(saveNoteFinder, findsOneWidget);

    await tester.tap(saveNoteFinder);
    await tester.pumpAndSettle();

    saveNoteScaffoldKey.currentState!.openEndDrawer();
    await tester.pumpAndSettle();

    // Drawer should contain Help option
    Finder helpFinder = find.text("Help");
    expect(helpFinder, findsOneWidget);

    await tester.tap(helpFinder);
    await tester.pumpAndSettle();

    helpScaffoldKey.currentState!.openEndDrawer();
    await tester.pumpAndSettle();
  });
}
