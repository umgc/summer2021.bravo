import 'package:flutter/material.dart';
import './basemenudrawer.dart';
import 'textnoteservice.dart';

/// Save Note page
class SavePersonalDetail extends StatefulWidget {
  const SavePersonalDetail({Key? key}) : super(key: key);

  @override
  _SavePersonalDetailState createState() => _SavePersonalDetailState();
}

class _SavePersonalDetailState extends State<SavePersonalDetail> {
  /// Text note service to use for I/O operations against local system
  final TextNoteService textNoteService = new TextNoteService();

  final keyController = TextEditingController();

  final textController = TextEditingController();
  _SavePersonalDetailState();

  @override
  void dispose() {
    keyController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: BaseMenuDrawer(),
      appBar: new AppBar(
        title: new Text('New Personal Detail'),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: keyController,
                maxLines: 1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the name of the detail you want to save'),
              ),
              Container(height: 15),
              TextField(
                controller: textController,
                maxLines: 14,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your personal detail value'),
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
                    textNoteService.savePersonalDetail(
                        keyController.text, textController.text);
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
        Navigator.pushNamed(context, '/view-details');
      },
    );

    // set up the dialog
    AlertDialog alert = AlertDialog(
      content: Text("Your personal detail has been saved."),
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
