import 'package:flutter/material.dart';
import './personalDetail.dart';
import './basemenudrawer.dart';
import 'textnoteservice.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'voicehelper.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// View Notes page
class ViewPersonalDetails extends StatefulWidget {
  const ViewPersonalDetails({Key? key}) : super(key: key);

  @override
  _ViewPersonalDetailsState createState() => _ViewPersonalDetailsState();
}

class _ViewPersonalDetailsState extends State<ViewPersonalDetails> {
  // flag to indicate if a voice search was performed
  bool voiceSearch = false;

  // flag for speech
  bool readResults = false;

  // Search bar to insert in the app bar header
  late SearchBar searchBar;

  // text to speech
  FlutterTts flutterTts = FlutterTts();

  /// Text note service to use for I/O operations against local system
  final TextNoteService textNoteService = new TextNoteService();

  // voice helper service
  final VoiceHelper voiceHelper = new VoiceHelper();

  /// Value of search filter to be used in filtering search results
  String searchFilter = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  _ViewPersonalDetailsState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: onCleared,
        buildDefaultAppBar: buildAppBar);
    searchFilter = "";
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(title: new Text('View Personal Details'), actions: [
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

  void voiceHandler(Map<String, dynamic> inference) {
    if (inference['isUnderstood']) {
      if (inference['intent'] == 'searchDetails') {
        print('Searching for: ' + inference['slots']['info']);
        onSubmitted(inference['slots']['info'].toString());
      }
    } else {
      // TODO handle not inferring
      print('did not understand');
    }
  }

  Future readFilterResults() async {
    List<dynamic> personalDetails =
        await textNoteService.getPersonalDetailList(searchFilter);
    if (!personalDetails.isEmpty) {
      if (readResults) {
        for (PersonalDetail detail in personalDetails) {
          readResults = false;
          await flutterTts
              .speak("Your " + searchFilter + " is " + detail.value.toString());
        }
      }
    } else if (searchFilter != "") {
      readResults = false;
      await flutterTts
          .speak("I'm sorry, I couldn't find anything for " + searchFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    voiceHelper.startPico(voiceHandler);

    return FutureBuilder<List<dynamic>>(
        future: textNoteService.getPersonalDetailList(searchFilter),
        builder: (context, AsyncSnapshot<List<dynamic>> personalDetails) {
          if (personalDetails.hasData) {
            readFilterResults();

            return Scaffold(
              key: _scaffoldKey,
              endDrawer: BaseMenuDrawer(),
              appBar: searchBar.build(context),
              body: Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: personalDetails.data == null ||
                          personalDetails.data?.length == 0
                      // No personal details found, alert the user
                      ? Text(
                          "Uh-oh! It looks like you don't have any personal details saved. Try saving some details first and come back here.")
                      // Add table rows for each personal detail
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
                                        child: Text('DETAIL',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text('VALUE',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ),
                                ]),
                            //not sure how to pass the correct element
                            for (var personalDetail
                                in personalDetails.data ?? [])
                              TableRow(children: <Widget>[
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/save-detail');
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(personalDetail.key)),
                                    )),
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          ViewPersonalDetail.routeName,
                                          arguments:
                                              personalDetail?.fileName ?? "",
                                        );
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            personalDetail.value,
                                          )),
                                    )),
                              ]),
                          ]),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/save-detail');
                },
                tooltip: 'Save New Detail',
                child: Icon(Icons.add),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
