import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> searchVerses() async {
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
  }

  bool isSearched = false; // Add this boolean flag

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text('Quran Search'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/body-01.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centering content vertically
            children: [
              Container(
                width: 500, // Set the desired width
                child: Center(
                  child: TextField(
                    controller: word,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(232, 223, 195, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2, // Adjust the border width
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                      labelText: 'Enter search word',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height:
                      10), // Added spacing between text field and radio buttons
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centering the radio buttons horizontally
                children: [
                  Radio(
                    activeColor: Colors.brown[900],
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Radio(
                    activeColor: Colors.brown[900],
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Radio(
                    activeColor: Colors.brown[900],
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromRGBO(232, 223, 195, 1))),
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
              if (errorMessage != null) Text(errorMessage!),
              if (isSearched)
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
                      elevation: 3,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(
                          result['Surah Name'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'الأية ${toArabicNumbers(result['Verse Number'].toString())}: ${result['Verse'] ?? ''}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () async {
                            var info = await get_ayah_info(result['Verse'],false);
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
