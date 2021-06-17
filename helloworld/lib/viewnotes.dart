import 'package:flutter/material.dart';
import './basemenudrawer.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

/*
* View Notes page
*/
class ViewNotes extends StatefulWidget {
  const ViewNotes({Key? key}) : super(key: key);

  @override
  _ViewNotesState createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  late SearchBar searchBar;

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
    return Scaffold(
      drawer: BaseMenuDrawer(),
      appBar: searchBar.build(context),
      body: Center(
        child: Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(.3),
            1: FlexColumnWidth()
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                children: <Widget>[
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.top,
                    child: Text(
                      'DATE',
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.top,
                    child: Text(
                      'SNIPPET',
                    ),
                  ),
                ]),
            TableRow(children: <Widget>[
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Text(
                  '06/15/2021',
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Text(
                  'It is a truth universally acknowledged, that a single man in possession of a good fortune, must be in want of a wife...',
                ),
              ),
            ]),
            TableRow(children: <Widget>[
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Text(
                  '06/16/2021',
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Text(
                  'As Gregor Samsa awoke one morning from uneasy dreams he found himself transformed in his bed into a gigantic insect...',
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
