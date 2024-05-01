import 'dart:convert';
import 'dart:html';


import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:http/http.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:quranicversee/home_page.dart';
import 'package:quranicversee/quran_main.dart';
import 'package:quranicversee/search_page.dart';
import 'package:quranicversee/voice_search_page.dart';
import 'package:quranicversee/model_page.dart';
import 'package:quranicversee/home_page.dart';
import 'ayah_info.dart';
import 'index.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    load_Data();
    return MaterialApp(
      
      home: BaseScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  bool loading = false;
  List data = [];


  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.search_outlined, size: 30),
   
    Icon(Icons.settings)
    
  ];
  int index = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/rm194-aew-11.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: HomePage(),
      ),
     bottomNavigationBar:Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.amber.shade50),
        ),
        child: CurvedNavigationBar(
          items: items,
          index: index,
          onTap: (index) {
            setState(() {
              if (index==1){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
              }
              this.index = index;
            });
          },
          backgroundColor: Color(0xffe0d2b4),
          color: Color(0xff195e59),
          animationCurve: Curves.ease,
          animationDuration: Duration(milliseconds: 300),
          buttonBackgroundColor: Color(0xffe0d2b4),
          
          // Set button background color to transparent
        ),
      ),
    );
  }
}
