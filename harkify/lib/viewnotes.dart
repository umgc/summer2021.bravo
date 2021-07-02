import 'package:flutter/material.dart';
import './notedetails.dart';
import './basemenudrawer.dart';
import 'textnoteservice.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:intl/intl.dart';

/// View Notes page
class ViewNotes extends StatefulWidget {
  const ViewNotes({Key? key}) : super(key: key);

  @override
  _ViewNotesState createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  // Search bar to insert in the app bar header
  late SearchBar searchBar;

  /// Text note service to use for I/O operations against local system
  final TextNoteService textNoteService = new TextNoteService();

  /// Date format to use when
  static final dateFormat = new DateFormat('yyyy-MM-dd hh:mm');

  _ViewNotesState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: print,
        buildDefaultAppBar: buildAppBar);
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('View Notes'),
        actions: [searchBar.getSearchAction(context)]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: textNoteService.getTextFileList(),
        builder: (context, AsyncSnapshot<List<dynamic>> textNotes) {
          if (textNotes.hasData) {
            return Scaffold(
              drawer: BaseMenuDrawer(),
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
                            1: FlexColumnWidth(.2),
                            2: FlexColumnWidth()
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                ),
                                children: <Widget>[
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'DATE',
                                        )),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'FAV',
                                        )),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'SNIPPET',
                                        )),
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
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/save-note');
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: textNote.isFavorite
                                              ? Icon(Icons.favorite)
                                              : Text("")),
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
