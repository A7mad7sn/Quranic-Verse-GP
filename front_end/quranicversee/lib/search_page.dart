import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'ayah_info.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController word = TextEditingController();
  int selectedRadio = 1;
  List<dynamic> data = [];
  String? errorMessage;
  bool isSearched = false;
  bool isLoading = false; // Added isLoading flag
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _text = "";
  bool _isListening = false;

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
      'word': wordText,
      'choice': selectedRadio,
    });

    try {
      var response = await http.post(
        Uri.parse("http://127.0.0.1:5000/search"),
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
          isLoading =
              false; // Set isLoading back to false after data is fetched
        });
      } else {
        setState(() {
          data = [];
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false; // Set isLoading back to false on error
        });
      }
    } catch (error) {
      setState(() {
        data = [];
        errorMessage = 'Error occurred: $error';
        isLoading = false; // Set isLoading back to false on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Color(0xffe8e0d5),
        title: Text(
          'Quran Search',
          style: GoogleFonts.elMessiri(
              textStyle: TextStyle(
                  fontSize: 30,
                  color: Color(0xff195e59),
                  fontWeight: FontWeight.bold)),
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                child: Center(
                  child: TextField(
                    controller: word,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffe8e0d5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Color(0xff195e59),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                      labelText: 'Enter search word',
                      prefixIcon: Icon(Icons.search),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xff195e59),
                          value: 1,
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = value!;
                            });
                          },
                        ),
                        Text(
                          'Basic Search',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xff195e59),
                          value: 2,
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = value!;
                            });
                          },
                        ),
                        Text(
                          'Search using Subset',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xff195e59),
                          value: 3,
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = value!;
                            });
                          },
                        ),
                        Text(
                          'Deep Search in Tafseer',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xffe8e0d5))),
                onPressed: () {
                  searchVerses();
                  setState(() {
                    isSearched = true;
                  });
                },
                child: Text(
                  'Search',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (errorMessage != null) Text(errorMessage!),
              if (isLoading) // Show loading indicator if isLoading is true
                CircularProgressIndicator(
                  color: Color(0xff195e59),
                ),
              if (isSearched && !isLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${data.length} Search Results',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final result = data[index];
                    return Card(
                      color: Color(0xff195e59),
                      elevation: 3,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(
                          result['Surah Name'] ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffe0d2b4)),
                        ),
                        subtitle: Text(
                          'الأية ${toArabicNumbers(result['Verse Number'].toString())}: ${result['Verse'] ?? ''}',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.info),
                          color: Color(0xffe0d2b4),
                          onPressed: () async {
                            var info =
                                await get_ayah_info(result['Verse'], false);
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
      ),
    );
  }
}
