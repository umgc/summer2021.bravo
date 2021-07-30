import 'package:picovoice/picovoice_manager.dart';
import 'package:picovoice/picovoice_error.dart';

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

// start the service
  Future<String> startPico(
      dynamic callback(Map<String, dynamic> inference)) async {

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
