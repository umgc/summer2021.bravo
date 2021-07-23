import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';
import 'basemenudrawer.dart';

class settingsPage extends StatefulWidget {
  final String title = "Settings";

  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: BaseMenuDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          padding: EdgeInsets.only(
            left: 16,
            top: 25,
            right: 16,
          ),
          child: SettingsList(
            sections: [
              SettingsSection(
                title: 'Section',
                tiles: [
                  SettingsTile(
                    title: 'Language',
                    subtitle: 'English',
                    leading: Icon(Icons.language),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile.switchTile(
                    title: 'Use fingerprint',
                    leading: Icon(Icons.fingerprint),
                    switchValue: true,
                    onToggle: (bool value) {},
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
