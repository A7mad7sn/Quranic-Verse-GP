import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'SectionDetailModel.dart';

class Sectiondetailscreen extends StatefulWidget {
  final int id;
  final String title;
  const Sectiondetailscreen({Key? key, required this.id, required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SectiondetailscreenState();
}

Color _fat7 = Color(0xffe8e0d5);
Color _8am2 = Color(0xff195e59);

class SectiondetailscreenState extends State<Sectiondetailscreen> {
  List<Sectiondetailmodel> sectionDetails = [];

  loadSections() async {
    sectionDetails = [];
    DefaultAssetBundle.of(context)
        .loadString("assets/azkar_section_details_db.json")
        .then((data) {
      var response = json.decode(data);
      response.forEach((sec) {
        Sectiondetailmodel section =
            Sectiondetailmodel.fromJson(sec as Map<String, dynamic>);
        if (section.sectionId == widget.id) {
          sectionDetails.add(section);
        }
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
          widget.title,
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
        color: _fat7,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Card(
              color: _8am2,
              child: ListTile(
                leading: Text(
                  "${sectionDetails[index].count}",
                  style: TextStyle(
                      color: _fat7, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                title: Text(
                  "${sectionDetails[index].reference}",
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.notoKufiArabic(
                      textStyle: TextStyle(
                          color: _fat7,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ),
                subtitle: Text(
                  "${sectionDetails[index].content}",
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.notoKufiArabic(
                      textStyle: TextStyle(
                          color: _fat7,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: sectionDetails.length,
        ),
      ),
    );
  }
}
