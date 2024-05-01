import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';

class VoiceSearchPage extends StatefulWidget {
  VoiceSearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => VoiceSearchPageState();
}

class VoiceSearchPageState extends State<VoiceSearchPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _text = "";
  bool _isListening = false;

  Map<String, int> arabicToInteger = {
    "الأولى":   1,
    "الثانيه": 2,
    "الثالثه": 3,
    "الرابعه": 4,
    "الخامسه": 5,
    "السادسه": 6,
    "السابعه": 7,
    "الثامنه": 8,
    "التاسعه": 9,
    "العاشره": 10
  };

  
  List<dynamic> data = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print('status: $status');
      },
      onError: (error) {
        print('error: $error');
      },
    );

    if (!available) {
      print('Speech recognition not available');
    }
  }

  void _listen() async {
    if (!_isListening) {
      setState(() {
        _isListening = true;
      });

      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
            arabicToInteger.forEach((key, value) {
              _text = _text.replaceAll(key, value.toString());
            });
            print(_text);
          });
        },
        localeId: 'ar', // Setting locale to Arabic (Egypt)
      );
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  Future<void> searchVerses() async {
    // Check if there's text to search for
    if (_text.isNotEmpty) {
      String wordText = _text;
      String jsonData = jsonEncode({
        "sentence": "$wordText",
      });

      try {
        var response = await http.post(
          Uri.parse("http://127.0.0.1:5000/command"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          setState(() {
            data = List.from(responseBody);
            errorMessage = null;
          });
        } else {
          setState(() {
            data = [];
            errorMessage = 'Failed to load data: ${response.statusCode}';
          });
        }
      } catch (error) {
        setState(() {
          data = [];
          errorMessage = 'Error occurred: $error';
        });
      }
    } else {
      setState(() {
        errorMessage = 'Please speak a word to search.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Search"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                _listen();
              },
              icon: Icon(Icons.mic),
              color: _isListening ? Colors.red : Colors.blue,
              iconSize: 50,
            ),
            SizedBox(height: 20),
            Text(
              _text,
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: searchVerses,
              child: Text('Search'),
            ),
            if (errorMessage != null) Text(errorMessage!),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final result = data[index];
                  return ListTile(
                    title: Text(result['Surah Name'] ?? ''),
                    subtitle: Text(
                      'Verse ${result['Verse Number']}: ${result['ayah'] ?? ''}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}
