import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranicversee/functions.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'ayah_info.dart';
import 'to_arabic_numbers.dart';
import 'surah_builder.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController _word = TextEditingController();
  int selectedRadio = 1;
  List<dynamic> data = [];
  String? errorMessage;
  bool isSearched = false;
  bool isLoading = false; // Added isLoading flag
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _text = "";
  bool _isListening = false;
  List<String> all_ayat = get_all_ayat();
  List<String> all_tafsir = get_all_tafsir();
  bool _isChecked = false;
  String _selectedOption = "القرآن";

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
            _word.text = _text;
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

  Future<void> searchVerses(List<String> searchList) async {
    setState(() {
      data = [];
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 200));

    String query = _word.text;

    if (_isChecked == false) {
      // Basic Search
      if (query.contains(RegExp(r'[ؤئأإ]'))) {
        String v1 = query.replaceAll(RegExp(r'[ؤئأإ]'), 'أ');
        String v2 = query.replaceAll(RegExp(r'[ؤئأإ]'), 'ئ');
        String v3 = query.replaceAll(RegExp(r'[ؤئأإ]'), 'ؤ');
        String v4 = query.replaceAll(RegExp(r'[ؤئأإ]'), 'ا');
        String v5 = query.replaceAll(RegExp(r'[أإ]'), 'ا');
        print(v1 + v2 + v3 + v4);
        List<String> matches = searchList
            .where((ayah) =>
                ayah.contains(v1) ||
                ayah.contains(v2) ||
                ayah.contains(v3) ||
                ayah.contains(v4) ||
                ayah.contains(v5))
            .toList();
        for (String match in matches) {
          data.add(await get_ayah_info(match, false));
        }
      } else {
        List<String> matches =
            searchList.where((ayah) => ayah.contains(query)).toList();

        for (String match in matches) {
          if (_selectedOption == "القرآن") {
            data.add(await get_ayah_info(match, false));
          } else {
            data.add(await get_tafsir_info(match));
          }
        }
      }
    } else {
      // Root Search
      bool searchWordInVerse(String word, String verse) {
        List<String> words = verse.split(' ');

        for (String w in words) {
          List<String> letters = w.split('');
          int index = 0;

          for (String letter in letters) {
            if (letter == word[index]) {
              index++;
              if (index == word.length) {
                return true;
              }
            }
          }
        }
        return false;
      }

      List<String> words = query.split(' ');
      for (String element in searchList) {
        if (words.every((word) => searchWordInVerse(word, element))) {
          if (_selectedOption == "القرآن") {
            data.add(await get_ayah_info(element, false));
          } else {
            data.add(await get_tafsir_info(element));
          }
        }
      }
    }

    setState(() {
      isLoading = false;
      isSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color _8am2 = Color(0xff195e59);
    Color _fat7 = Color(0xffe0d2b4);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _fat7,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: _8am2,
        title: Text(
          'محرك البحث',
          textDirection: TextDirection.rtl,
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    onSubmitted: (value) async {
                      if (_selectedOption == "القرآن")
                        await searchVerses(all_ayat);
                      else
                        await searchVerses(all_tafsir);
                    },
                    controller: _word,
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
                      labelText: 'أدخل كلمة البحث',
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
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: _fat7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        alignment: Alignment.centerRight,
                        style: TextStyle(
                          color: _8am2,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          
                        ),
                        value: _selectedOption,
                        items: <String>['القرآن', ' التفسير المختصر'].map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: Alignment.centerRight,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedOption = newValue!;
                          });
                        },
                      ),
                    ),
                    Text(
                      'البحث في : ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                    checkColor: _fat7,
                    activeColor: _8am2,
                  ),
                  Text(
                    'كلمة جذرية',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 60,right: 60),
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(_fat7)),
                        onPressed: () async {
                          if (_selectedOption == "القرآن")
                                await searchVerses(all_ayat);
                              else
                                await searchVerses(all_tafsir);
                        },
                        child: Text('بحث',style: TextStyle(color: _8am2,fontWeight: FontWeight.bold,fontSize: 18),),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if (isLoading) // Show loading indicator if isLoading is true
                CircularProgressIndicator(
                  color: Color(0xff195e59),
                ),
              if (isSearched && !isLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${toArabicNumbers(data.length.toString())} نتيجة',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl,
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
                              fontWeight: FontWeight.bold,
                              color: Color(0xffe0d2b4)),
                        ),
                        subtitle: Text(
                          'الآية ${toArabicNumbers(result['number'].toString())} : ${result['ayah'] ?? ''}',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.info),
                          color: Color(0xffe0d2b4),
                          onPressed: () async {
                            var info =
                                await get_ayah_info(result['ayah'], false);
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
