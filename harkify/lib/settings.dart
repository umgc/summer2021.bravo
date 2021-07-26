import 'package:flutter/material.dart';
import 'basemenudrawer.dart';
import 'textnoteservice.dart';

class settingsPage extends StatefulWidget {
  final String title = "Settings";

  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  /// Text note service to use for I/O operations against local system
  final TextNoteService textNoteService = new TextNoteService();

  String numberDaysKeepFiles = "1";
  String numberSecondsBeforeStop = "1";

  _setValues(days, seconds) {
    numberDaysKeepFiles = days;
    numberSecondsBeforeStop = seconds;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: textNoteService.getSettings(),
        builder: (context, AsyncSnapshot<dynamic> settings) {
          _setValues(settings.data?.daysToKeepFiles ?? "7",
              settings.data?.secondsSilence ?? "5");

          return Scaffold(
              endDrawer: BaseMenuDrawer(),
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: IntrinsicHeight(
                      //row with 2 spaced columns
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.deepPurple),
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.deepPurple.shade300),
                                ),
                                onPressed: () {
                                  // create the Azure voice profile
                                },
                                child: Text('Create Voice Profile',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                          Container(width: 15),
                          //delete icon
                          Column(
                            children: <Widget>[
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.deepPurple),
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.deepPurple.shade300),
                                ),
                                onPressed: () {
                                  // test the Azure voice profile
                                },
                                child: Text('Test Voice Profile',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: IntrinsicHeight(
                      //row with 2 spaced columns
                      child: Row(
                        children: <Widget>[
                          Container(
                            constraints:
                                BoxConstraints(minWidth: 175, maxWidth: 175),
                            margin: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              "Number of Days to Keep Text Notes",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          ),
                          Container(width: 15),
                          //delete icon
                          Column(
                            children: <Widget>[
                              DropdownButton<String>(
                                value: numberDaysKeepFiles,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 30,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.deepPurple, fontSize: 20),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    textNoteService.updateSettings(new Setting(
                                        newValue.toString(),
                                        numberSecondsBeforeStop));
                                    numberDaysKeepFiles = newValue.toString();
                                  });
                                },
                                items: <String>[
                                  '7',
                                  '8',
                                  '9',
                                  '10',
                                  '11',
                                  '12',
                                  '13',
                                  '14',
                                  '15',
                                  '16',
                                  '17',
                                  '18',
                                  '19',
                                  '20',
                                  '21',
                                  '22',
                                  '23',
                                  '24',
                                  '25',
                                  '26',
                                  '27',
                                  '28',
                                  '29',
                                  '30'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: IntrinsicHeight(
                      //row with 2 spaced columns
                      child: Row(
                        children: <Widget>[
                          Container(
                            constraints:
                                BoxConstraints(minWidth: 175, maxWidth: 175),
                            margin: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              "Number of Seconds of Silence Before Stopping Recording",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          ),
                          Container(width: 15),
                          //delete icon
                          Column(
                            children: <Widget>[
                              DropdownButton<String>(
                                value: numberSecondsBeforeStop,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 30,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.deepPurple, fontSize: 20),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    textNoteService.updateSettings(new Setting(
                                        numberDaysKeepFiles,
                                        newValue.toString()));
                                    numberSecondsBeforeStop =
                                        newValue.toString();
                                  });
                                },
                                items: <String>[
                                  '5',
                                  '6',
                                  '7',
                                  '8',
                                  '9',
                                  '10',
                                  '11',
                                  '12',
                                  '13',
                                  '14',
                                  '15'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        });
  }
}
