import 'package:flutter/material.dart';

/// Base menu for all pages
class BaseMenuDrawer extends StatelessWidget {
  final Color backgroundColor = Colors.blue;

  const BaseMenuDrawer() : super();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Text('Menu'),
          ),
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
        ],
      ),
    );
  }
}
