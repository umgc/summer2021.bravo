import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

import 'basemenudrawer.dart';

class NoteDetails extends StatefulWidget {
  NoteDetails({Key? key}) : super(key: key);

  @override
  State<NoteDetails> createState() => _NoteDetailssState();
}

class _NoteDetailssState extends State<NoteDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final String NoteString =
      ('''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.''');

  @override
  Widget build(BuildContext context) {
    TextEditingController editController = TextEditingController()
      ..text = NoteString;

    return Scaffold(
      key: _scaffoldKey,
      drawer: BaseMenuDrawer(),
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
                        margin: const EdgeInsets.only(top: 10, left: 30),
                        child: Center(
                          child: Text(
                            '6/21/2021\n3:05 PM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
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
                        onPressed: null,
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 60.0,
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
                        onPressed: null,
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 60.0,
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
              controller: editController,
              enabled: false,
              focusNode: FocusNode(),
              enableInteractiveSelection: false,
              maxLines: null,
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
