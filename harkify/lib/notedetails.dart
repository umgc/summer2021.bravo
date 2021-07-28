import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'textnoteservice.dart';

class NoteDetails extends StatefulWidget {
  NoteDetails({
    Key? key,
  }) : super(key: key);

  //route set here to allow for arguments to be passed - Alec
  static const routeName = '/note-details';

  @override
  State<NoteDetails> createState() => _NoteDetailssState();
}

class _NoteDetailssState extends State<NoteDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final editController = TextEditingController();
  String edits = "";
  static final dateFormat = new DateFormat('yyyy-MM-dd\nhh:mm');

  /// Text note service to use for I/O operations against local system
  final TextNoteService textNoteService = new TextNoteService();

  @override
  void initState() {
    super.initState();
    editController.addListener(_storeLatestValue);
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    editController.dispose();
    super.dispose();
  }

  void _storeLatestValue() {
    edits = ('${editController.text}');
  }

  @override
  Widget build(BuildContext context) {
    //This method returns the current route with the arguments - Alec
    final args = ModalRoute.of(context)!.settings.arguments as String?;

    return FutureBuilder<dynamic>(
        future: textNoteService.getTextFile(args ?? ""),
        builder: (context, AsyncSnapshot<dynamic> selectedNote) {
          //passed Note text is set here - Alec
          if (selectedNote.hasData) {
            editController.text = selectedNote.data?.text ?? "";

            return Scaffold(
              key: _scaffoldKey,
              //drawer: BaseMenuDrawer(),
              appBar: AppBar(title: Text('Notes')),
              body: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: IntrinsicHeight(
                      //row with 3 spaced columns
                      child: Row(
                        children: <Widget>[
                          //date column
                          Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    //passed date String should display here - Alec
                                    dateFormat
                                        .format(selectedNote.data.dateTime),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(flex: 1),
                          //edit icon
                          Column(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () async {
                                  textNoteService.updateTextFile(new TextNote(
                                      selectedNote.data.fileName,
                                      selectedNote.data.dateTime,
                                      edits,
                                      false));
                                  Navigator.pushNamed(context, '/view-notes');
                                },
                                child: Icon(
                                  Icons.save,
                                  color: Colors.blue,
                                  size: 50.0,
                                  semanticLabel: 'Edit Note',
                                ),
                              ),
                            ],
                          ),
                          Spacer(flex: 1),
                          //delete icon
                          Column(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () async {
                                  textNoteService.deleteTextFile(new TextNote(
                                      selectedNote.data.fileName,
                                      selectedNote.data.dateTime,
                                      edits,
                                      false));
                                  Navigator.pushNamed(context, '/view-notes');
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 50.0,
                                  semanticLabel: 'Delete Note',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    //text field should enable when user selects edit icon
                    padding: EdgeInsets.all(30.0),
                    child: TextField(
                      //this is where the note text displays see editController - Alec
                      controller: editController,
                      enabled: true,
                      focusNode: FocusNode(),
                      enableInteractiveSelection: true,
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
