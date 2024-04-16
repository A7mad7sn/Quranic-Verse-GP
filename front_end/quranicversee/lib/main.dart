import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:http/http.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:quranicversee/search_page.dart';
import 'package:quranicversee/voice_search_page.dart';
import 'package:quranicversee/model_page.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arabic Speech to Text',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  List data = [];

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.search_outlined, size: 30),
    Icon(Icons.mic, size: 30),
    Icon(FlutterIslamicIcons.quran2, size: 30),
    Icon(FlutterIslamicIcons.tasbih2, size: 30),
  ];
  int index = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Quranic Verse', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/rm194-aew-11.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: MaterialButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () async {
                        var response = await get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
                        var response_body = jsonDecode(response.body);
                        data.addAll(response_body);
                        setState(() {});
                        print(response_body[0]['title']);
                      },
                      child: Text("API request"),
                    ),
                  ),
                ],
              ),
            ),
            ...List.generate(data.length, (index) => Card(
              child: ListTile(
                title: Text("${data[index]['title']}"),
              ),
            )),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(iconTheme: IconThemeData(color: Colors.amber.shade50)),
        child: CurvedNavigationBar(
          items: items,
          index: index,
          onTap: (index) {
            setState(() {
              if (index == 1) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
              }else if (index==2) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => VoiceSearchPage())); 
              }else if (index==3) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModelPage())); 
              }
              else {
                this.index=index;
              }
            });
          },
          backgroundColor: Colors.transparent,
          color: Colors.orange,
          animationCurve: Curves.ease,
          animationDuration: Duration(milliseconds: 300),
          buttonBackgroundColor: Colors.amber.shade500,
        ),
      ),
    );
  }
}
