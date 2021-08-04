import 'package:flutter/material.dart';
import 'textnoteservice.dart';

class ViewPersonalDetail extends StatefulWidget {
  ViewPersonalDetail({
    Key? key,
  }) : super(key: key);

  //route set here to allow for arguments to be passed
  static const routeName = '/view-detail';

  @override
  State<ViewPersonalDetail> createState() => _ViewPersonalDetailsState();
}

class _ViewPersonalDetailsState extends State<ViewPersonalDetail> {
  final editController = TextEditingController();
  String edits = "";

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
    //This method returns the current route with the arguments
    final args = ModalRoute.of(context)!.settings.arguments as String?;

    return FutureBuilder<dynamic>(
        future: textNoteService.getPersonalDetail(args ?? ""),
        builder: (context, AsyncSnapshot<dynamic> selectedDetail) {
          //passed Note text is set here - Alec
          if (selectedDetail.hasData) {
            editController.text = selectedDetail.data?.value ?? "";

            return Scaffold(
              //drawer: BaseMenuDrawer(),
              appBar: AppBar(title: Text('Personal Detail')),
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
                          //spacer
                          Column(
                            children: <Widget>[
                              Container(
                                constraints:
                                    BoxConstraints(minWidth: 90, maxWidth: 150),
                                margin: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    selectedDetail.data.key,
                                    textAlign: TextAlign.left,
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
                                  textNoteService.updatePersonalDetail(
                                      new PersonalDetail(
                                          selectedDetail.data.fileName,
                                          selectedDetail.data.key,
                                          edits));
                                  Navigator.pushNamed(context, '/view-details');
                                },
                                child: Icon(
                                  Icons.save,
                                  color: Colors.blue,
                                  size: 50.0,
                                  semanticLabel: 'Edit Details',
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
                                  textNoteService.deletePersonalDetail(
                                      new PersonalDetail(
                                          selectedDetail.data.fileName,
                                          selectedDetail.data.key,
                                          edits));
                                  Navigator.pushNamed(context, '/view-details');
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 50.0,
                                  semanticLabel: 'Delete Detail',
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
