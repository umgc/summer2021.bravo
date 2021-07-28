import 'package:flutter/material.dart';
import './notedetails.dart';
import './basemenudrawer.dart';
import 'textnoteservice.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:intl/intl.dart';
import 'voicehelper.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  final TextNoteService textNoteService = new TextNoteService();

  // voice helper service
  final VoiceHelper voiceHelper = new VoiceHelper();

  /// Date format to use when
  static final dateFormat = new DateFormat('yyyy-MM-dd hh:mm');

  /// Value of search filter to be used in filtering search results
  String searchFilter = "";

  /// Search is submitted from search bar
  onSubmitted(value) {
    if (voiceSearch) {
      voiceSearch = false;
      readResults = true;
    }
    searchFilter = value;
    setState(() => _scaffoldKey.currentState);
  }

  // Search has been cleared from search bar
  onCleared() {
    searchFilter = "";
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    } else {
      // TODO handle not inferring
      print('did not understand');
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
    } else if (searchFilter != "") {
      readResults = false;
      await flutterTts
          .speak("I'm sorry, I couldn't find anything for " + searchFilter);
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
              key: _scaffoldKey,
              endDrawer: BaseMenuDrawer(),
              appBar: searchBar.build(context),
              body: Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: textNotes.data == null || textNotes.data?.length == 0
                      // No text notes found, tell user
                      ? Text(
                          "Uh-oh! It looks like you don't have any text notes saved. Try saving some notes first and come back here.")
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
                                                color: Colors.white))),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text('SNIPPET',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ),
                                ]),
                            //not sure how to pass the correct element
                            for (var textNote in textNotes.data ?? [])
                              TableRow(children: <Widget>[
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/save-note');
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            dateFormat
                                                .format(textNote.dateTime),
                                          )),
                                    )),
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
                                          child: Text(
                                            textNote.text,
                                          )),
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
