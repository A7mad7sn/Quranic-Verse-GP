import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

class PrayerPage extends StatefulWidget {
  List<String> prayerTimings;
  // Assuming this is in "HH:mm" format

  PrayerPage({required this.prayerTimings});

  @override
  State<StatefulWidget> createState() => PrayerPageState();
}

class PrayerPageState extends State<PrayerPage> {
  Color background = Color(0xffe8e0d5);
  Color f_color = Color(0xff195e59);
  String _time = "";

  List<String> prayTimings = [];
  List<String> prayerNames = [
    "الفجر",
    "الشروق",
    "الظهر",
    "العصر",
    "المغرب",
    "العشاء"
  ];

  List<Icon> icons = [
    Icon(
      WeatherIcons.cloudy_gusts,
      size: 30,
      color: Colors.white,
    ),
    Icon(
      WeatherIcons.sunrise,
      size: 30,
      color: Colors.white,
    ),
    Icon(
      Icons.sunny,
      size: 30,
      color: Colors.white,
    ),
    Icon(
      WeatherIcons.day_light_wind,
      size: 30,
      color: Colors.white,
    ),
    Icon(
      WeatherIcons.sunset,
      size: 30,
      color: Colors.white,
    ),
    Icon(
      WeatherIcons.night_alt_cloudy,
      size: 30,
      color: Colors.white,
    )
  ];

  void _updateTime() {
    setState(() {
      _time = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });

    // Example: Selecting specific timings by indexes
    // Make sure the indexes are within bounds of prayerTimings list
    prayTimings = [
      widget.prayerTimings[0],
      widget.prayerTimings[1],
      widget.prayerTimings[2], // Example: third item
      widget.prayerTimings[3],
      widget.prayerTimings[5],
      widget.prayerTimings[6]
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: f_color,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: background,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'مواقيت الصلاة',
          style: TextStyle(
              color: background, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: background,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: f_color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      "images/awyyy-01.png",
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "الوقت الحالي",
                      style: GoogleFonts.notoKufiArabic(
                          textStyle:
                              TextStyle(color: background, fontSize: 30)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _time,
                      style: GoogleFonts.elMessiri(
                          textStyle:
                              TextStyle(color: background, fontSize: 40)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: prayTimings.length,
                      itemBuilder: (context, index) {
                        final String result = prayTimings[index];
                        return Card(
                          color: Color(0xff195e59),
                          elevation: 3,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Container(
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  result,
                                  style: GoogleFonts.elMessiri(
                                      textStyle: TextStyle(
                                          fontSize: 30, color: Colors.white)),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      prayerNames[index],
                                      style: GoogleFonts.notoKufiArabic(
                                          textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                      )),
                                    ),
                                    SizedBox(
                                        width:
                                            10), // Spacing between text and icon
                                    icons[index],
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
