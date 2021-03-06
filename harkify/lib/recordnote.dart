import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'basemenudrawer.dart';
import 'textnoteservice.dart';
import 'voicehelper.dart';

final recordNoteScaffoldKey = GlobalKey<ScaffoldState>();

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText _speech = SpeechToText();

  bool _isListening = false;
  String _textSpeech = 'Press the mic button to start';

  /// Text note service to use for I/O operations against local system
  final TextNoteService textNoteService = new TextNoteService();

  // voice helper service
  final VoiceHelper voiceHelper = new VoiceHelper();

  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;

    if (!isFirstTime) {
      prefs.setBool('first_time', false);
      print('Not the first time here');
      return false;
    } else {
      prefs.setBool('first_time', false);
      Navigator.pushNamed(context, '/create-profile');
      return true;
    }
  }

  void onListen() async {
    if (!_isListening) {
      voiceHelper.stopPico();
      _textSpeech = "";

      bool available = await _speech.initialize(
        onStatus: (val) => {
          if (val == 'notListening') {print('onStatus: $val')}
        },
        onError: (val) => print('onError: $val'),
        debugLogging: true,
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
            onResult: (val) => setState(() {
                  _textSpeech = val.recognizedWords;
                }));
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
        // check to see if any text was transcribed
        if (_textSpeech != '' &&
            _textSpeech != 'Press the mic button to start') {
          // if it was, then save it as a note
          textNoteService.saveTextFile(_textSpeech, false);
          showConfirmDialog(context);
        }
      });
    }
  }

  void voiceHandler(Map<String, dynamic> inference) {
    if (inference['isUnderstood']) {
      if (inference['intent'] == 'startTranscription') {
        print('start recording');
        voiceHelper.stopPico();
        onListen();
      }
      if (inference['intent'] == 'searchNotes') {
        print('Searching notes');
        Navigator.pushNamed(context, '/view-notes');
      }
      if (inference['intent'] == 'searchDetails') {
        print('Searching for personal detail');
        Navigator.pushNamed(context, '/view-details');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Sorry, I did not understand'),
          backgroundColor: Colors.deepOrange,
          duration: const Duration(seconds: 1)));
    }
  }

  @override
  void initState() {
    super.initState();
    _isListening = false;
    _speech = SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isListening) {
      voiceHelper.startPico(voiceHandler);
    } else {
      voiceHelper.stopPico();
    }

    isFirstTime();

    return Scaffold(
      key: recordNoteScaffoldKey,
      endDrawer: BaseMenuDrawer(),
      appBar: AppBar(title: Text('Record a Note')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 80,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: () {
            onListen();
          },
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 150),
            child: Text(
              _textSpeech,
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            )),
      ),
    );
  }

  /// Show a dialog message confirming note was saved
  showConfirmDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pushNamed(context, '/view-notes');
      },
    );

    // set up the dialog
    AlertDialog alert = AlertDialog(
      content: Text("The text note was saved successfully."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
