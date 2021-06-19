import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Encapsulates all file I/O for text notes
class TextNoteService {
  /// Returns the correct file directory for all text notes
  static Future<Directory> _getTextNotesDirectory() async {
    final Directory docsDirectory = await getApplicationDocumentsDirectory();
    final notesDirectory = new Directory('${docsDirectory.path}/harkify');
    notesDirectory.createSync();
    return notesDirectory;
  }

  /// Returns the proper text file name based on the current date/time
  static String _getNewFileName() {
    var now = DateTime.now();
    String fileName = now.toString();
    return "textnote_" + fileName;
  }

  /// Save a text note file to local storage
  static saveTextFile(String text) async {
    try {
      var textNotesDirectory = await _getTextNotesDirectory();
      String newFileName = _getNewFileName();
      final File file = File('${textNotesDirectory.path}/$newFileName');

      await file.writeAsString(text);
      print("File saved: ${file.path}");
    } catch (e) {
      print("ERROR-Couldn't save file: ${e.toString()}");
    }
  }

  /// Return a text note file, specified by name
  static Future<TextNote> getTextFile(String fileName) async {
    String text = "";
    var textNotesDirectory = await _getTextNotesDirectory();

    try {
      final File file = File('${textNotesDirectory.path}/$fileName');
      text = await file.readAsString();

      print("File retrieved: ${file.path}");
    } catch (e) {
      print("ERROR-Couldn't read file: ${e.toString()}");
    }

    return new TextNote(fileName, text);
  }

  /// Return a list of all saved text files
  static Future<List<dynamic>> getTextFileList() async {
    List textFileList = <TextNote>[];
    try {
      var textNotesDirectory = await _getTextNotesDirectory();

      await for (var entity
          in textNotesDirectory.list(recursive: false, followLinks: false)) {
        if (!entity.path.contains("textnote_")) continue;

        final File file = File('${entity.path}');
        String teaserText = await file.readAsString();
        if (teaserText.length > 100) {
          teaserText = teaserText.substring(0, 100).trimRight() + "...";
        }

        textFileList.add(new TextNote(entity.path, teaserText));

        print("File retrieved: ${file.path}");
      }
    } catch (e) {
      print("ERROR-Couldn't read file: ${e.toString()}");
    }

    return textFileList;
  }
}

/// Defines a specific text note
class TextNote {
  /// Name of the text note file
  String? fileName;

  /// Date and time when the text note was saved
  DateTime? dateTime;

  /// Actual text of the text note
  String? text;

  /// Constructor takes file name and text
  TextNote(this.fileName, this.text) {
    if (this.fileName != null) {
      int dateStartsAt = this.fileName?.lastIndexOf("_") ?? 0;
      String? datePortionOfName = this.fileName?.substring(dateStartsAt + 1);
      this.dateTime = DateTime.tryParse(datePortionOfName ?? "");
    }
  }
}
