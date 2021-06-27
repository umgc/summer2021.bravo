import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'dart:io';

/// Encapsulates all file I/O for text notes
class TextNoteService {
  /// Maximum length for teaser excerpt from text note, shown in View Notes list
  static final teaserLength = 100;

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
  static saveTextFile(String text, bool isFavorite) async {
    try {
      var textNotesDirectory = await _getTextNotesDirectory();
      String newFileName = _getNewFileName();
      final File file = File('${textNotesDirectory.path}/$newFileName');

      String textNoteXml = '''<?xml version="1.0"?>
        <text-note>
          <is-favorite>$isFavorite</is-favorite>
          <text>$text</text>
        </text-note>''';
      await file.writeAsString(textNoteXml);
      print("File saved: ${file.path}");
    } catch (e) {
      print("ERROR-Couldn't save file: ${e.toString()}");
    }
  }

  /// Return a text note object, specified by file name
  static Future<TextNote> getTextFile(String fileName) async {
    try {
      final File file = File('$fileName');
      String fileText = file.readAsStringSync();
      final document = XmlDocument.parse(fileText);

      print("File retrieved: ${file.path}");

      String text =
          document.getElement("text-note")?.getElement("text")?.innerText ?? "";
      bool isFavorite = document
              .getElement("text-note")
              ?.getElement("is-favorite")
              ?.innerText ==
          "true";
      return new TextNote(fileName, text, isFavorite);
    } catch (e) {
      print("ERROR-Couldn't read file: ${e.toString()}");
    }

    // Should only get here if there's an error, so we don't care about the text note
    return TextNote(fileName, "(Could not read file)", false);
  }

  /// Return a list of all saved text files
  static Future<List<dynamic>> getTextFileList() async {
    List textFileList = <TextNote>[];
    try {
      var textNotesDirectory = await _getTextNotesDirectory();

      await for (var entity
          in textNotesDirectory.list(recursive: false, followLinks: false)) {
        if (!entity.path.contains("textnote_")) continue;

        var textNote = await getTextFile(entity.path);
        if ((textNote.text?.length ?? 0) > teaserLength) {
          textNote.text =
              (textNote.text ?? "").substring(0, teaserLength).trimRight() +
                  "...";
        }

        textFileList.add(textNote);
      }
    } catch (e) {
      print("ERROR-Couldn't read file: ${e.toString()}");
    }

    // Sort by date note was recorded
    textFileList.sort((a, b) => b.dateTime?.compareTo(a.dateTime));
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

  /// Whether or not this text file is flagged as a favorite
  bool isFavorite = false;

  /// Constructor takes file name and text
  TextNote(this.fileName, this.text, this.isFavorite) {
    if (this.fileName != null) {
      int dateStartsAt = this.fileName?.lastIndexOf("_") ?? 0;
      String? datePortionOfName = this.fileName?.substring(dateStartsAt + 1);
      this.dateTime = DateTime.tryParse(datePortionOfName ?? "");
    }
  }
}
