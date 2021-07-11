import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:encrypt/encrypt.dart';

/// Encapsulates all file I/O for text notes
class TextNoteService {
  /// Maximum length for teaser excerpt from text note, shown in View Notes list
  static final teaserLength = 100;

  /// Encryption key to use in encrypting and decrypting text notes
  final _encryptionKey = 'b4CplJtMrcfEg7LJhL2dZyEwgvHP/75w';

  /// The file system to use for all I/O operations. Generally LocalFileSystem()
  /// but MemoryFileSystem() is used when running unit tests.
  FileSystem fileSystem;

  /// Constructor initializes FileSystem
  TextNoteService({this.fileSystem = const LocalFileSystem()});

  /// Returns the correct file directory for all text notes
  Future<Directory> _getTextNotesDirectory() async {
    var docsDirectory = fileSystem.directory(".");

    try {
      if (fileSystem is LocalFileSystem) {
        // Docs folder only available for Android and IOS, not unit tests
        var docsPath = (await getApplicationDocumentsDirectory()).path;
        docsDirectory = fileSystem.directory(docsPath);

        final notesDirectory =
            fileSystem.directory('${docsDirectory.path}/harkify');
        notesDirectory.createSync();
        return notesDirectory;
      }
    } catch (MissingPluginException) {}

    return docsDirectory;
  }

  /// Returns the proper text file name based on the current date/time
  String _getNewFileName() {
    var now = DateTime.now();
    String fileName = now.toString();
    return "textnote_" + fileName;
  }

  /// Encrypt a plain text note and serialize it as a base-64 string
  String _encryptNote(plainNote) {
    final key = Key.fromUtf8(_encryptionKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encryptedNote = encrypter.encrypt(plainNote, iv: iv);
    return encryptedNote.base64;
  }

  /// Decrypt an encrypted text note serialized as a base-64 string
  String _decryptNote(base64Note) {
    final key = Key.fromUtf8(_encryptionKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encryptedNote = Encrypted.fromBase64(base64Note);
    final decryptedNote = encrypter.decrypt(encryptedNote, iv: iv);
    return decryptedNote;
  }

  /// Save a text note file to local storage
  Future<String> saveTextFile(String text, bool isFavorite) async {
    try {
      var textNotesDirectory = await _getTextNotesDirectory();
      String newFileName = _getNewFileName();
      int dateStartsAt = newFileName.lastIndexOf("_");
      String? datePortionOfName = newFileName.substring(dateStartsAt + 1);
      final File file =
          fileSystem.file('${textNotesDirectory.path}/$newFileName');

      String textNoteXml = '''<?xml version="1.0"?>
        <text-note>
          <file-name>$newFileName</file-name>
          <when-recorded>$datePortionOfName</when-recorded>        
          <is-favorite>$isFavorite</is-favorite>
          <text>$text</text>
        </text-note>''';

      final encryptedNote = _encryptNote(textNoteXml);
      await file.writeAsString(encryptedNote);
      print("File saved: ${file.path}");
      return newFileName;
    } catch (e) {
      print("ERROR-Couldn't save file: ${e.toString()}");
    }

    return "";
  }

  /// Update a text note file to local storage
  updateTextFile(TextNote updatedNote) async {
    try {
      var textNotesDirectory = await _getTextNotesDirectory();
      var fileName = updatedNote.fileName;
      final File file = fileSystem.file('${textNotesDirectory.path}/$fileName');

      String textNoteXml = '''<?xml version="1.0"?>
        <text-note>
          <file-name>$fileName</file-name>
          <when-recorded>${updatedNote.dateTime.toString()}</when-recorded>        
          <is-favorite>${updatedNote.isFavorite}</is-favorite>
          <text>${updatedNote.text}</text>
        </text-note>''';
      final encryptedNote = _encryptNote(textNoteXml);
      await file.writeAsString(encryptedNote);
      print("File saved: ${file.path}");
    } catch (e) {
      print("ERROR-Couldn't update file: ${e.toString()}");
    }
  }

  /// Delete a text note file in local storage
  deleteTextFile(TextNote updatedNote) async {
    try {
      var textNotesDirectory = await _getTextNotesDirectory();
      var fileName = updatedNote.fileName;
      final File file = fileSystem.file('${textNotesDirectory.path}/$fileName');

      await file.delete();
      print("File deleted: ${file.path}");
    } catch (e) {
      print("ERROR-Couldn't delete file: ${e.toString()}");
    }
  }

  /// Return a text note object, specified by file name
  Future<TextNote> getTextFile(String fileName) async {
    try {
      var textNotesDirectory = await _getTextNotesDirectory();
      final File file = fileSystem.file('${textNotesDirectory.path}/$fileName');
      String fileText = file.readAsStringSync();

      final decryptedNote = _decryptNote(fileText);
      final document = XmlDocument.parse(decryptedNote);

      print("File retrieved: ${file.path}");

      String text =
          document.getElement("text-note")?.getElement("text")?.innerText ?? "";
      bool isFavorite = document
              .getElement("text-note")
              ?.getElement("is-favorite")
              ?.innerText ==
          "true";
      DateTime? whenRecorded = DateTime.tryParse(document
              .getElement("text-note")
              ?.getElement("when-recorded")
              ?.innerText ??
          "");
      return new TextNote(fileName, whenRecorded, text, isFavorite);
    } catch (e) {
      print("ERROR-Couldn't read file: ${e.toString()}");
    }

    // Should only get here if there's an error, so we don't care about the text note
    return TextNote(fileName, DateTime.now(), "(Could not read file)", false);
  }

  /// Return a list of all saved text files
  Future<List<dynamic>> getTextFileList(String searchFilter) async {
    List textFileList = <TextNote>[];
    try {
      var textNotesDirectory = await _getTextNotesDirectory();

      await for (var entity
          in textNotesDirectory.list(recursive: false, followLinks: false)) {
        if (!entity.path.contains("textnote_")) continue;

        var fileName = entity.path.substring(entity.path.indexOf("textnote_"));
        var textNote = await getTextFile(fileName);
        if ((textNote.text?.length ?? 0) > teaserLength) {
          textNote.text =
              (textNote.text ?? "").substring(0, teaserLength).trimRight() +
                  "...";
        }

        if (searchFilter.length == 0) {
          // No search filter, so just add it
          textFileList.add(textNote);
        } else {
          // Check for all search terms separately since they may not show up together
          bool found = true;
          List<String> searchTerms = searchFilter.split(' ');

          searchTerms.forEach((searchTerm) {
            if (!(textNote.text?.toLowerCase() ?? "")
                .contains(searchTerm.toLowerCase())) {
              found = false;
            }
          });

          if (found) {
            textFileList.add(textNote);
          }
        }
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

  /// Date and time when the text note was recorded
  DateTime? dateTime;

  /// Actual text of the text note
  String? text;

  /// Whether or not this text file is flagged as a favorite
  bool isFavorite = false;

  /// Constructor takes all properties as params
  TextNote(this.fileName, this.dateTime, this.text, this.isFavorite);
}
