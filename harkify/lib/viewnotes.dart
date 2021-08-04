import 'package:flutter/material.dart';
import './notedetails.dart';
import './basemenudrawer.dart';
import 'textnoteservice.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import 'package:intl/intl.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

import 'voicehelper.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:timeago/timeago.dart' as timeago;

final viewNotesScaffoldKey = GlobalKey<ScaffoldState>();

/// View Notes page
class ViewNotes extends StatefulWidget {
  const ViewNotes({Key? key}) : super(key: key);

  @override
  _ViewNotesState createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  // flag to control whether or not results are read
  bool readResults = false;

  // flag to indicate a voice search
  bool voiceSearch = false;

  // Search bar to insert in the app bar header
  late SearchBar searchBar;

  // text to speech
  FlutterTts flutterTts = FlutterTts();

  /// Text note service to use for I/O operations against local system
  TextNoteService textNoteService = new TextNoteService();

  // voice helper service
  final VoiceHelper voiceHelper = new VoiceHelper();

  /// Value of search filter to be used in filtering search results
  String searchFilter = "";

  /// Search is submitted from search bar
  onSubmitted(value) {
    if (voiceSearch) {
      voiceSearch = false;
      readResults = true;
    }
    searchFilter = value;
    setState(() => viewNotesScaffoldKey.currentState);
  }

  // Search has been cleared from search bar
  onCleared() {
    searchFilter = "";
  }

  _ViewNotesState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: onCleared,
        buildDefaultAppBar: buildAppBar);
    searchFilter = "";
  }

  void voiceHandler(Map<String, dynamic> inference) {
    if (inference['isUnderstood']) {
      if (inference['intent'] == 'searchNotes') {
        print('Searching for: ' + inference['slots']['date']);
        voiceSearch = true;
        onSubmitted(inference['slots']['date'].toString());
      }
      if (inference['intent'] == 'startTranscription') {
        print('start recording');
        Navigator.pushNamed(context, '/record-notes');
      }
      if (inference['intent'] == 'searchDetails') {
        print('Searching for personal detail');
        Navigator.pushNamed(context, '/view-details');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Sorry, I did not understand'),
          backgroundColor: Colors.deepOrange,
          duration: const Duration(seconds: 1)));
    }
  }

  Future readFilterResults() async {
    List<dynamic> textNotes =
        await textNoteService.getTextFileList(searchFilter);
    if (!textNotes.isEmpty) {
      if (readResults) {
        for (TextNote note in textNotes) {
          readResults = false;
          await flutterTts.speak("Your reminders for " +
              searchFilter +
              " are: " +
              note.text.toString());
        }
      }
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(title: new Text('View Notes'), actions: [
      searchBar.getSearchAction(context),
      Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    voiceHelper.startPico(voiceHandler);

    return FutureBuilder<List<dynamic>>(
        future: textNoteService.getTextFileList(searchFilter),
        builder: (context, AsyncSnapshot<List<dynamic>> textNotes) {
          if (textNotes.hasData) {
            readFilterResults();
            return Scaffold(
              key: viewNotesScaffoldKey,
              endDrawer: BaseMenuDrawer(),
              appBar: searchBar.build(context),
              body: Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: textNotes.data == null || textNotes.data?.length == 0
                      // No text notes found, tell user
                      ? Text(
                          "Uh-oh! It looks like you don't have any text notes saved. Try saving some notes first and come back here.",
                          style: TextStyle(
                            fontSize: 20,
                          ))
                      // Add table rows for each text note
                      : Table(
                          border: TableBorder.all(),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(.45),
                            1: FlexColumnWidth()
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                                decoration: const BoxDecoration(
                                    color: Colors.deepPurple),
                                children: <Widget>[
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text('DATE',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white))),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text('SNIPPET',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white))),
                                  ),
                                ]),
                            //not sure how to pass the correct element
                            for (var textNote in textNotes.data ?? [])
                              TableRow(children: <Widget>[
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.top,
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                          timeago.format(textNote.dateTime),
                                          style: TextStyle(fontSize: 20))),
                                ),
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    // text button used to test exact solution from
                                    // https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments
                                    // - Alec

                                    /*   child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/save-note');
                                        },
                                        
                                            */
                                    child: TextButton(
                                      onPressed: () {
                                        // When the user taps the button,
                                        // navigate to a named route and
                                        // provide the arguments as an optional
                                        // parameter.
                                        Navigator.pushNamed(
                                          context,
                                          NoteDetails.routeName,
                                          arguments: textNote?.fileName ?? "",
                                        );
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(textNote.text,
                                              style: TextStyle(
                                                fontSize: 20,
                                              ))),
                                    )),
                              ]),
                          ]),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/save-note');
                },
                tooltip: 'Save Note',
                child: Icon(Icons.add),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
