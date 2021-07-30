import 'package:Harkify/textnoteservice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';

/// Run all application setting related tests from the TextNoteService class
void main() {
  /// The file system to use for all I/O operations without saving real files
  FileSystem fileSystem = MemoryFileSystem();

  /// Text note service to use for I/O operations against mock file system
  TextNoteService textNoteService = new TextNoteService(fileSystem: fileSystem);

  /// Some preparatory steps to take before executing a text note service test
  prepForTests() {
    // Reinitialize file system and service so we're starting from a blank slate
    fileSystem = MemoryFileSystem();
    textNoteService = new TextNoteService(fileSystem: fileSystem);
  }

  test('Setting should be saved', () async {
    prepForTests();
    String filename = await textNoteService.saveSettings(new Setting("1", "2"));

    File newFile = fileSystem.file('$filename');
    bool newFileExists = await newFile.exists();
    // There should be a filename returned
    expect(filename == "", false);
    // Text fileshould be there
    expect(newFileExists, true);
  });

  test('Setting should be retrieved', () async {
    prepForTests();
    await textNoteService.saveSettings(new Setting("1", "2"));

    Setting setting = await textNoteService.getSettings();

    // The setting retrieved should match the one created above
    expect(setting.daysToKeepFiles, "1");
    expect(setting.secondsSilence, "2");
  });

  test('Setting should be updated', () async {
    prepForTests();
    await textNoteService.saveSettings(new Setting("1", "2"));

    Setting setting = await textNoteService.getSettings();
    setting.daysToKeepFiles = "3";
    setting.secondsSilence = "4";
    await textNoteService.updateSettings(setting);

    Setting updatedSetting = await textNoteService.getSettings();

    // The setting retrieved should match the one updated above
    expect(updatedSetting.daysToKeepFiles, "3");
    expect(updatedSetting.secondsSilence, "4");
  });
}
