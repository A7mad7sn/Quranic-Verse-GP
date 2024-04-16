import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool isSearched=false ;

  Future<void> searchVerses() async {
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
  
@override
Widget build(BuildContext context) {
  return Scaffold(
    extendBody: true,
    appBar: AppBar(
      title: Text("Model Search"),
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
                  fillColor: Color.fromRGBO(232, 223, 195, 1),
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
                  labelText: 'Enter search word',
                  suffixIcon: Icon(Icons.search),
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
                  fillColor: Color.fromRGBO(232, 223, 195, 1),
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
                backgroundColor: MaterialStateProperty.all(Color.fromRGBO(232, 223, 195, 1)),
              ),
              onPressed: () {
                searchVerses();
                setState(() {
                  isSearched = true;
                });
              },
              child: Text(
                'Search',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
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
                        '${"Verse:"}: ${result['ayah'] ?? ''}',
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