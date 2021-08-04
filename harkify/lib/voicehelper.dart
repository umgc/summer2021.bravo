import 'dart:io' show Platform;
import 'package:picovoice/picovoice_manager.dart';
import 'package:picovoice/picovoice_error.dart';
import 'textnoteservice.dart';

class VoiceHelper {
  PicovoiceManager? _picovoiceManager;

  // Constructor
  VoiceHelper() {
    try {
      _picovoiceManager = PicovoiceManager.create(
          "assets/ok_so.ppn",
          _wakeWordCallbackDefault,
          "assets/note_taker.rhn",
          _infererenceCallbackDefault,
          errorCallback: _errorCallback);
    } catch(ex) {
      print(ex.toString());
    }
  }

  Future<String> stopPico() async {
    await _picovoiceManager!.stop();
    return "pico service stopped";
  }

  String _WakeWordfileName = "ok_so.ppn", _RhinoFileName = "";
//Get the filepath of the wake word
  Future<String> _getWakeWordPath() async {
    final TextNoteService textNoteService = new TextNoteService();
    Setting setting = await textNoteService.getSettings();
    _WakeWordfileName = setting.pathToWakeWord ?? "ok_so.ppn";
    return _WakeWordfileName;
  }

// start the service
  Future<String> startPico(
      dynamic callback(Map<String, dynamic> inference)) async {

    await _getWakeWordPath().toString();

    if (Platform.isAndroid) {
      // Android-specific code
      _WakeWordfileName = "assets/Android/" +
          _WakeWordfileName.replaceAll("assets/Android/", "");
      _RhinoFileName = "assets/Android/note_taker.rhn";
    } else if (Platform.isIOS) {
      // iOS-specific code
      _WakeWordfileName =
          "assets/iOS/" + _WakeWordfileName.replaceAll("assets/iOS/", "");
      _RhinoFileName = "assets/iOS/note_taker.rhn";
    }
    _picovoiceManager = PicovoiceManager.create(
        _WakeWordfileName, _wakeWordCallbackDefault, _RhinoFileName, callback,
        errorCallback: _errorCallback);


    try {
      _picovoiceManager = PicovoiceManager.create("assets/ok_so.ppn",
          _wakeWordCallbackDefault, "assets/note_taker.rhn", callback,
          errorCallback: _errorCallback);
      await _picovoiceManager!.start();
      return "pico service started";
    } on PvAudioException catch (ex) {
      // deal with audio exception
      print(ex.message);
      return "pico service could not be started";
    } on PvError catch (ex) {
      // deal with Picovoice init error
      print(ex.message);
      return "pico service could not be started";
    } catch (ex) {
      print(ex.toString());
      return "pico service could not be started";
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
