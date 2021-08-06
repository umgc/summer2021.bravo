import 'package:flutter/material.dart';
import 'basemenudrawer.dart';
import 'textnoteservice.dart';

//final settingsScaffoldKey = GlobalKey<ScaffoldState>();

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
  String wakeWordPath = "ok_so.ppn";

  _setValues(days, seconds, wakeWord) {
    numberDaysKeepFiles = days;
    numberSecondsBeforeStop = seconds;
    switch (wakeWord) {
      case "ok_so.ppn":
        wakeWordPath = 'Ok, so';
        break;
      case "I_see_so.ppn":
        wakeWordPath = 'I see, so';
        break;
      case "alright_then.ppn":
        wakeWordPath = 'Alright then';
        break;
      default:
        wakeWordPath = 'Ok, so';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: textNoteService.getSettings(),
        builder: (context, AsyncSnapshot<dynamic> settings) {
          _setValues(
              settings.data?.daysToKeepFiles ?? "7",
              settings.data?.secondsSilence ?? "5",
              settings.data?.pathToWakeWord ?? "ok_so.ppn");

          return Scaffold(
              //key: settingsScaffoldKey,
              endDrawer: BaseMenuDrawer(),
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: ListView(
                children: <Widget>[
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
                      // create the Azure voice profile
                      //_launchURL();
                      Navigator.pushNamed(context, '/create-profile');
                    },
                    child: Text('Create and Test Voice Profile'),
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
                                        numberSecondsBeforeStop,
                                        wakeWordPath));
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
                                        newValue.toString(),
                                        wakeWordPath));
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
                              "What phrase should wake the app up?",
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
                                value: wakeWordPath,
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
                                  String saveVal = "";
                                  switch (newValue) {
                                    case 'Ok, so':
                                      saveVal = "ok_so.ppn";
                                      break;
                                    case 'I see, so':
                                      saveVal = "I_see_so.ppn";
                                      break;
                                    case 'Alright then':
                                      saveVal = "alright_then.ppn";
                                      break;
                                    default:
                                      saveVal = newValue.toString();
                                      break;
                                  }
                                  setState(() {
                                    textNoteService.updateSettings(new Setting(
                                        numberDaysKeepFiles,
                                        numberSecondsBeforeStop,
                                        saveVal));
                                    wakeWordPath = saveVal;
                                  });
                                },
                                items: <String>[
                                  'Ok, so',
                                  'I see, so',
                                  'Alright then'
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
