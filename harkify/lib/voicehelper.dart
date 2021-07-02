import 'dart:io' show Platform;

import 'package:path_provider/path_provider.dart';
import 'package:picovoice/picovoice_manager.dart';
import 'package:picovoice/picovoice_error.dart';

class VoiceHelper {
  PicovoiceManager _picovoiceManager = PicovoiceManager.create(
      "assets/ok_so.ppn",
      _wakeWordCallbackDefault,
      "assets/note_taker.rhn",
      _infererenceCallbackDefault,
      errorCallback: _errorCallback);

  // Constructor
  VoiceHelper() {
    _startPico();
  }

// start the service
  void _startPico() async {
    try {
      await _picovoiceManager.start();
    } on PvAudioException catch (ex) {
      // deal with audio exception
      print(ex.message);
    } on PvError catch (ex) {
      // deal with Picovoice init error
      print(ex.message);
    }
  }
}

// handle the wake word being detected
void _wakeWordCallbackDefault() {
  print("wake word detected!");
}

// handle errors
void _errorCallback(PvError error) {
  // handle error
}

// handle rhino inference
void _infererenceCallbackDefault(Map<String, dynamic> inference) {
  print(inference);
}
