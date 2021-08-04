import 'package:Harkify/textnoteservice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';

/// Run all personal detail related tests from the TextNoteService class
void main() {
  /// The file system to use for all I/O operations without saving real files
  FileSystem fileSystem = MemoryFileSystem();

  /// Text note service to use for I/O operations against mock file system
  TextNoteService textNoteService = new TextNoteService();

  /// Some preparatory steps to take before executing a text note service test
  prepForTests() {
    // Reinitialize file system and service so we're starting from a blank slate
    fileSystem = MemoryFileSystem();
    TextNoteService.fileSystem = fileSystem;
  }

  test('Personal detail should be saved', () async {
    prepForTests();
    String filename =
        await textNoteService.savePersonalDetail("Phone Number", "1234567890");

    File newFile = fileSystem.file('$filename');
    bool newFileExists = await newFile.exists();
    // There should be a filename returned
    expect(filename == "", false);
    // Text file should be there
    expect(newFileExists, true);
  });

  test('Personal detail should be retrieved', () async {
    prepForTests();
    String filename =
        await textNoteService.savePersonalDetail("Phone Number", "1234567890");

    PersonalDetail personalDetail =
        await textNoteService.getPersonalDetail(filename);

    // The personal detail retrieved should match the one created above
    expect(personalDetail.fileName, filename);
    expect(personalDetail.key, "Phone Number");
    expect(personalDetail.value, "1234567890");
  });

  test('Personal detail should be updated', () async {
    prepForTests();
    String filename =
        await textNoteService.savePersonalDetail("Phone Number", "1234567890");

    PersonalDetail personalDetail =
        await textNoteService.getPersonalDetail(filename);
    personalDetail.key = "Social Security Number";
    personalDetail.value = "1112223333";
    await textNoteService.updatePersonalDetail(personalDetail);

    PersonalDetail updatedDetail =
        await textNoteService.getPersonalDetail(filename);

    // The personal detail retrieved should match the one updated above
    expect(updatedDetail.fileName, filename);
    expect(updatedDetail.key, "Social Security Number");
    expect(updatedDetail.value, "1112223333");
  });

  test('Personal detail should be deleted', () async {
    prepForTests();
    String filename =
        await textNoteService.savePersonalDetail("Phone Number", "1234567890");

    await textNoteService.deletePersonalDetail(
        new PersonalDetail(filename, "Phone Number", "1112223333"));

    // Text file for personal detail should be missing now
    bool fileExists = await fileSystem.file('$filename').exists();
    expect(fileExists, false);
  });

  test('Personal detail list should be retrieved', () async {
    prepForTests();
    String filename =
        await textNoteService.savePersonalDetail("Phone Number", "1234567890");

    List<dynamic> detailList = await textNoteService.getPersonalDetailList("");

    // The personal detail list retrieved should match the one created above
    expect(detailList.length, 1);
    expect(detailList[0].fileName, filename);
    expect(detailList[0].key, "Phone Number");
    expect(detailList[0].value, "1234567890");
  });
}
