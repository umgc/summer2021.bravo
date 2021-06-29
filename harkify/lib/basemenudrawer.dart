import 'package:flutter/material.dart';

/// Base menu for all pages
class BaseMenuDrawer extends StatelessWidget {
  
  final Color backgroundColor = Colors.deepPurpleAccent;

  const BaseMenuDrawer() : super();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              height: 50.0,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: Text('Menu', style: TextStyle(color: Colors.white)),
              )),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            title: Text('Save Note'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/save-note');
            },
          ),
          ListTile(
            title: Text('View Notes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/view-notes');
            },
          ),
          ListTile(
            title: Text('Record Note'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/record-notes');
            },
          ),
        ],
      ),
    );
  }
}
