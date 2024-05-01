import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'ayah_info.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class ModelPage extends StatefulWidget {
  ModelPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ModelPageState();
}

class ModelPageState extends State<ModelPage> {
  TextEditingController word = TextEditingController();
  int selectedRadio = 1;
  List<dynamic> data = [];
  String? errorMessage;
  bool isSearched = false;
  bool isLoading  = false;
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
      'verseNumber': selectedRadio,
    });

    try {
      var response = await http.post(
        Uri.parse("http://127.0.0.1:5000/model"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Color(0xffe8e0d5),
        title: Text("Model Search",style: GoogleFonts.elMessiri(
              textStyle: TextStyle(
                  fontSize: 30,
                  color: Color(0xff195e59),
                  fontWeight: FontWeight.bold)),),
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
                width: 500,
                child: TextField(
                  controller: word,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffe8e0d5),
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
                    labelText: 'Enter the topic',
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
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: 200,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffe8e0d5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    labelText: 'Enter verse number',
                  ),
                  onChanged: (value) {
                    // Handle the changed value
                    setState(() {
                      selectedRadio = int.tryParse(value) ?? selectedRadio;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color(0xffe8e0d5)),
                ),
                onPressed: () {
                  searchVerses();
                  setState(() {
                    isSearched = true;
                  });
                },
                child: Text(
                  'Search',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            if (errorMessage != null) Text(errorMessage!),
            if (isLoading) // Show loading indicator if isLoading is true
                CircularProgressIndicator(color: Color(0xff195e59),),
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
            SizedBox(height: 10), // Added spacing before the search results
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
                          "${index + 1}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffe0d2b4)),
                        ),
                        subtitle: Text(
                          '${result['ayah'] ?? ''}',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.info),
                          color: Color(0xffe0d2b4),
                          onPressed: () async {
                            var info = await get_ayah_info(result['ayah'],false);
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  build_info_Dialog(info, context),
                            );
                          },
                        )),
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
