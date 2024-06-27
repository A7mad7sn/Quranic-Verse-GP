import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranicversee/constant.dart';
import 'package:quranicversee/functions.dart';
import 'package:quranicversee/surah_builder.dart';
import 'ayah_info.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ModelPage extends StatefulWidget {
  ModelPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ModelPageState();
}

class ModelPageState extends State<ModelPage> {
  TextEditingController word = TextEditingController();
  List<dynamic> data = [];
  String? errorMessage;
  bool isSearched = false;
  bool isLoading = false;
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _text = "";
  bool _isListening = false;

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

  void _listen(BuildContext context) async {
    if (!_isListening) {
      setState(() {
        _isListening = true;
      });

      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
            // Set the recognized words to the text field
            word.text = _text;
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
    setState(() {
      isLoading = true; // Set isLoading to true while fetching data
    });

    String wordText = word.text;
    String jsonData = jsonEncode({
      'text': wordText,
      'verseNumber': numberOfAyat,
    });

    try {
      var response = await http.post(
        Uri.parse("http://192.168.1.11:5000/model"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        data = List.from(responseBody);
        List<dynamic> results = [];
        for (var d in data) {
          results.add(await get_ayah_info(d['ayah'], false));
        }
        data = results;
        setState(() {
          errorMessage = null;
          isLoading = false;
        });
      } else {
        setState(() {
          data = [];
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        data = [];
        errorMessage = 'Error occurred: $error';
        isLoading = false;
      });
    }
  }

  Color _8am2 = Color(0xff195e59);
  Color _fat7 = Color(0xffe0d2b4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: _8am2,
        centerTitle: true,
        title: Text(
          "مرشد الآيات",
          style: GoogleFonts.elMessiri(
              textStyle: TextStyle(
                  fontSize: 30, color: _fat7, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/back2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                child: TextField(
                  onSubmitted: (value) {
                    searchVerses();
                    setState(() {
                      isSearched = true;
                    });
                  },
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  controller: word,
                  decoration: InputDecoration(
                    hintText: 'معصية قوم ما لله و اصطيادهم يوم حرم الصيد',
                    filled: true,
                    fillColor: _fat7,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.mic),
                            onPressed: () {
                              _listen(context);
                            },
                            color: _isListening
                                ? Color.fromARGB(255, 73, 48, 12)
                                : Color(0xff195e59)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (errorMessage != null)
              Expanded(
                  child: Center(
                      child: Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                color: _8am2,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(
                    Icons.cancel,
                    color: _fat7,
                    size: 100,
                  ),
                ),
              ))),
            if (isLoading) // Show loading indicator if isLoading is true
              CircularProgressIndicator(
                color: _8am2,
              ),
            if (isSearched && !isLoading)
              SizedBox(height: 10), // Added spacing before the search results
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final result = data[index];
                  return Card(
                    color: _8am2,
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      onTap: () {
                        navigateToQuranVerse(
                            context,
                            int.parse(toEnglishNumbers(result['number'])),
                            result['surah']);
                      },
                      title: Text(
                        result['surah'] ?? '',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: _fat7),
                      ),
                      subtitle: Text(
                        'الآية ${toArabicNumbers(result['number'].toString())} : ${result['ayah'] ?? ''}',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.info),
                        color: _fat7,
                        onPressed: () async {
                          var info = await get_ayah_info(result['ayah'], false);
                          showDialog(
                            context: context,
                            builder: (context) =>
                                build_info_Dialog(info, context),
                          );
                        },
                      ),
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
}
