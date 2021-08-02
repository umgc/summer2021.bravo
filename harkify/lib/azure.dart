import 'dart:async';
import 'dart:convert';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:http/http.dart' as http;

/// Encapsulates the calls to Azure
class Azure {
  Azure() {}

  Future<dynamic> speechToText(String filePath) async {
    FileSystem fileSystem = const LocalFileSystem();
    final File file = fileSystem.file(filePath);
    print('filepath is: ' + file.path);

    final bytes = file.readAsBytesSync();
    print('the number of bytes of data: ' + bytes.length.toString());
    var response;
    Map<String, dynamic> responseBody;
    var recognizedVoiceText;
    try {
      response = await http.post(
        Uri.parse(
            "https://westus.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US"),
        body: bytes,
        headers: <String, String>{
          'Ocp-Apim-Subscription-Key': 'b6e8188efdce487e98e48bcc0cfd2e3d',
          'Content-Type': 'audio/wav'
        },
      );

      // The response body is a string that needs to be decoded as a json in order to get the extract the text.
      print('the response code: ' + response.statusCode.toString());
      print('the response body: ' + response.body);
      responseBody = jsonDecode(response.body);
      recognizedVoiceText = responseBody["DisplayText"];
    } catch (e) {
      print('Error: ${e.toString()}');
      recognizedVoiceText = "Something went wrong";
    }
    return recognizedVoiceText;
  }
}
