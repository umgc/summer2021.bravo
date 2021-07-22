import 'package:flutter/material.dart';
import './basemenudrawer.dart';
import 'textnoteservice.dart';

/// Save Note page
class SaveNote extends StatefulWidget {
  const SaveNote({Key? key}) : super(key: key);

  @override
  _SaveNoteState createState() => _SaveNoteState();
}

class _SaveNoteState extends State<SaveNote> {
  /// Text note service to use for I/O operations against local system
  final TextNoteService textNoteService = new TextNoteService();

  final textController = TextEditingController();
  _SaveNoteState();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BaseMenuDrawer(),
      appBar: new AppBar(
        title: new Text('Save Note'),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: textController,
                maxLines: 15,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your note\'s text'),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                  overlayColor: MaterialStateProperty.all<Color>(
                      Colors.deepPurple.shade300),
                ),
                onPressed: () {
                  if (textController.text.length > 0) {
                    textNoteService.saveTextFile(textController.text, false);
                    showConfirmDialog(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          )),
    );
  }

  /// Show a dialog message confirming note was saved
  showConfirmDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pushNamed(context, '/view-notes');
      },
    );

    // set up the dialog
    AlertDialog alert = AlertDialog(
      content: Text("The text note was saved successfully."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
