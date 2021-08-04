import 'package:flutter/material.dart';

import 'notedetails.dart';
import 'savenote.dart';
import 'viewnotes.dart';
import 'recordnote.dart';
import 'help.dart';
import 'settings.dart';
import 'savePersonalDetail.dart';
import 'personalDetails.dart';
import 'personalDetail.dart';
import 'recordVoice.dart';
import 'textnoteservice.dart';


void main() {
  // Purge old notes before starting up application
  final TextNoteService textNoteService = new TextNoteService();
  textNoteService.purgeOldNotes();

  runApp(MyApp());
}

/// Home page
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harkify',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/record-notes',
      routes: {
        '/save-note': (context) => SaveNote(),
        '/save-detail': (context) => SavePersonalDetail(),
        '/view-notes': (context) => ViewNotes(),
        '/note-details': (context) => NoteDetails(),
        '/record-notes': (context) => SpeechScreen(),
        '/view-details': (context) => ViewPersonalDetails(),
        '/view-detail': (context) => ViewPersonalDetail(),
        '/settings': (context) => settingsPage(),
        '/help': (context) => HelpPage(),
        '/create-profile': (context) => CreateProfile(),
      },
    );
  }
}
