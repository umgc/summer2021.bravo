import 'package:file/file.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Encapsulates the calls to Azure
class Azure {
  Future<dynamic> speechToText(File file) async {
    final bytes = file.readAsBytesSync();

    var headers = {
      'Ocp-Apim-Subscription-Key': 'b6e8188efdce487e98e48bcc0cfd2e3d',
      'Content-Type': 'audio/wav'
    };

    var response;
    Map<String, dynamic> responseBody;
    var recognizedVoiceText;

    try {
      response = await http.post(
        Uri.parse(
            "https://summer2021bravo.cognitiveservices.azure.com/language=en-us"),
        body: bytes,
        headers: headers,
      );

      // The response body is a string that needs to be decoded as a json in order to get the extract the text.
      responseBody = jsonDecode(response.body);
      recognizedVoiceText = responseBody["DisplayText"];
    } catch (e) {
      print('Error: ${e.toString()}');
      recognizedVoiceText = "Something went wrong";
    }

    return recognizedVoiceText;
  }
}
