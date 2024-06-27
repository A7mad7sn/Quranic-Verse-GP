import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranicversee/SectionDetailScreen.dart';
import 'package:quranicversee/section_model.dart';

class AzkarPage extends StatefulWidget {
  AzkarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AzkarPageState();
}

List<SectionModel> sections = [];

Color _fat7 = Color(0xffe8e0d5);
Color _8am2 = Color(0xff195e59);

class AzkarPageState extends State<AzkarPage> {
  loadSections() async {
    DefaultAssetBundle.of(context)
        .loadString("assets/azkar_sections_db.json")
        .then((data) {
      var response = json.decode(data);
      response.forEach((sec) {
        SectionModel section =
            SectionModel.fromJson(sec as Map<String, dynamic>);
        sections.add(section);
      });
      setState(() {});
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    loadSections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: _8am2,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _fat7,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'الأذكار',
          style: GoogleFonts.notoKufiArabic(
            textStyle: TextStyle(
              color: _fat7,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _fat7,
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: sections.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    SectionModel section = sections[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Sectiondetailscreen(
                                id: section.id!, title: section.name!)));
                        // For example, navigate to a new screen or perform an action
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0), // Adjust vertical spacing as needed
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            color: _8am2,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${section.name}", // Assuming 'title' is a field in SectionModel
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle: TextStyle(
                                        color: _fat7,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  // Additional widgets for the card content
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
