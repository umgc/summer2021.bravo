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
              height: 85.0,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: Text('Menu', style: TextStyle(color: Colors.white)),
              )),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Save Note'),
            subtitle: Text('Create a new note'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/save-note');
            },
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('View Notes'),
            subtitle: Text('View your saved notes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/view-notes');
            },
          ),
          ListTile(
            leading: Icon(Icons.mic_rounded),
            title: Text('Record Note'),
            subtitle: Text('Record a New Note'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/record-notes');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My Details'),
            subtitle: Text('View and edit user details'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            subtitle: Text('Edit user settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
