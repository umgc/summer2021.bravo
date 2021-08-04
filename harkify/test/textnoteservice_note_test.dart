import 'package:Harkify/textnoteservice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';

/// Run all text note related tests from the TextNoteService class
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

  test('Text note should be saved', () async {
    prepForTests();
    String filename = await textNoteService.saveTextFile(
        "The quick, brown fox jumps over the lazy dog 1 2 3 4 5 6 7 8 9 0.",
        false);

    File newFile = fileSystem.file('$filename');
    bool newFileExists = await newFile.exists();
    // There should be a filename returned
    expect(filename == "", false);
    // Text file should be there
    expect(newFileExists, true);
  });

  test('Text note should be retrieved', () async {
    prepForTests();
    DateTime rightNow = DateTime.now().add(const Duration(seconds: -1));
    String filename = await textNoteService.saveTextFile(
        "The quick, brown fox jumps over the lazy dog 1 2 3 4 5 6 7 8 9 0.",
        false);

    TextNote textNote = await textNoteService.getTextFile(filename);

    // The text note retrieved should match the one created above
    expect(textNote.fileName, filename);
    expect(rightNow.compareTo(textNote.dateTime ?? DateTime.now()), -1);
    expect(textNote.isFavorite, false);
    expect(textNote.text,
        "The quick, brown fox jumps over the lazy dog 1 2 3 4 5 6 7 8 9 0.");
  });

  test('Text note should be updated', () async {
    prepForTests();
    DateTime rightNow = DateTime.now().add(const Duration(seconds: -1));
    String filename = await textNoteService.saveTextFile(
        "The quick, brown fox jumps over the lazy dog 1 2 3 4 5 6 7 8 9 0.",
        false);

    TextNote textNote = await textNoteService.getTextFile(filename);
    textNote.isFavorite = true;
    textNote.text =
        "Twas brillig, and the slithy toves did gyre and gimble in the wabe.";
    await textNoteService.updateTextFile(textNote);

    TextNote updatedNote = await textNoteService.getTextFile(filename);

    // The text note retrieved should match the one updated above
    expect(updatedNote.fileName, filename);
    expect(rightNow.compareTo(updatedNote.dateTime ?? DateTime.now()), -1);
    expect(updatedNote.isFavorite, true);
    expect(updatedNote.text,
        "Twas brillig, and the slithy toves did gyre and gimble in the wabe.");
  });

  test('Text note should be deleted', () async {
    prepForTests();
    DateTime rightNow = DateTime.now().add(const Duration(seconds: -1));
    String filename = await textNoteService.saveTextFile(
        "The quick, brown fox jumps over the lazy dog 1 2 3 4 5 6 7 8 9 0.",
        false);

    await textNoteService
        .deleteTextFile(new TextNote(filename, rightNow, "", false));

    // Text file for note should be missing now
    bool fileExists = await fileSystem.file('$filename').exists();
    expect(fileExists, false);
  });

  test('Text note list should be retrieved', () async {
    prepForTests();
    DateTime rightNow = DateTime.now().add(const Duration(seconds: -1));
    String filename = await textNoteService.saveTextFile(
        "The quick, brown fox jumps over the lazy dog 1 2 3 4 5 6 7 8 9 0.",
        false);

    List<dynamic> textNoteList = await textNoteService.getTextFileList("");

    // The text note list retrieved should match the one created above
    expect(textNoteList.length, 1);
    expect(textNoteList[0].fileName, filename);
    expect(rightNow.compareTo(textNoteList[0].dateTime ?? DateTime.now()), -1);
    expect(textNoteList[0].isFavorite, false);
    expect(textNoteList[0].text,
        "The quick, brown fox jumps over the lazy dog 1 2 3 4 5 6 7 8 9 0.");
  });
}
