import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:quranicversee/azkar.dart';
import 'package:quranicversee/hadith_page.dart';
import 'package:quranicversee/index.dart';
import 'package:quranicversee/masbaha.dart';
import 'package:quranicversee/model_page.dart';
import 'package:quranicversee/qibla_page.dart';
import 'package:quranicversee/prayer_timesPage.dart';
import 'functions.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Color _8am2 = Color(0xff195e59);
  Color _fat7 = Color(0xffe0d2b4);


  String _gregorianDate = '';
  String _hijriDate = '';
  String _time = '';

  String locationMessage = "";
  String URL = "http://api.aladhan.com/v1/timings/";

  Position? _currentPosition;
  List<String> prayerTimings = [];




  List<Widget> icons = [
    Icon(FlutterIslamicIcons.solidQuran, size: 60, color: Color(0xffe0d2b4),),
    Icon(FlutterIslamicIcons.tasbih2 , size: 60, color: Color(0xffe0d2b4),),
    Icon(FlutterIslamicIcons.qibla , size: 60, color: Color(0xffe0d2b4),),
    Icon(FlutterIslamicIcons.prayingPerson , size: 60, color: Color(0xffe0d2b4),),
    Icon(FlutterIslamicIcons.islam , size: 60, color: Color(0xffe0d2b4),),
    Icon(FlutterIslamicIcons.crescentMoon,  size: 60, color: Color(0xffe0d2b4),)
  ];

  List<String> texts = [
    "مرشد الآيات",
    "المسبحة",
    "القبلة",
    "مواقيت الصلاة",
    "أحاديث",
    "الأذكار"
  ];

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
    _getCurrentLocation().then((_) {
      _updateURL();
      _fetchPrayerTimings();
    });
  }

  void _updateDateTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final HijriCalendar hijriDate = HijriCalendar.fromDate(now);

    setState(() {
      _gregorianDate = formatter.format(now);
       // Formatting Gregorian date with Arabic month name
      _hijriDate =
      '${toArabicNumbers(hijriDate.hDay.toString())}-${getHijriMonthName(
          hijriDate.hMonth)}-${toArabicNumbers(hijriDate.hYear.toString())}';
      _time = DateFormat('HH:mm').format(now);
    });
  }

  void _updateTime() {
    setState(() {
      _time = DateFormat('HH:mm').format(DateTime.now());
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await determinePosition();
      setState(() {
        _currentPosition = position;
        locationMessage =
        "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        _updateURL();
        _fetchPrayerTimings();
      });
    } catch (e) {
      setState(() {
        locationMessage = "Error: ${handleLocationError(e)}";
      });
    }
  }



  Future<void> _fetchPrayerTimings() async {
    try {
      final response = await http.get(Uri.parse(URL));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        Map<String, dynamic> timings = responseData['data']['timings'];
        List<String> timingsList = timings.values.cast<String>().toList();

        setState(() {
          prayerTimings = timingsList;

        });
      } else {
        setState(() {
          prayerTimings = [];
        });
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        prayerTimings = [];
      });
      print("Exception occurred: $e");
    }
  }
  void _updateURL() {
    setState(() {
      URL =
      "http://api.aladhan.com/v1/timings/${_gregorianDate}?latitude=${_currentPosition
          ?.latitude}&longitude=${_currentPosition?.longitude}&method=5";
    });
    print(URL);
  }


  @override
  Widget build(BuildContext context) {
    final List<VoidCallback> functions = [
          () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => ModelPage())),
          () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => MasbahaPage())),
          () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => QiblaPage())),
          () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => PrayerPage(prayerTimings: prayerTimings))),
          () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => HadithPage())),
          () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => AzkarPage())),
      // Add more functions as needed
    ];


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Quranic Verse",
          style: GoogleFonts.elMessiri(
            textStyle: TextStyle(
              color: _fat7,
              fontWeight: FontWeight.w800,
              fontSize: 40,
            ),
          ),
        ),
        backgroundColor: _8am2,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _fat7,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${toArabicNumbers(_gregorianDate.toString())}',
                    style: GoogleFonts.notoKufiArabic(
                      textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[900],
                      ),
                    ),
                  ),
                  Text(
                    '$_hijriDate',
                    style: GoogleFonts.notoKufiArabic(
                      textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[900],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const IndexPage()));
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'القرآن الكريم',
                        style: GoogleFonts.notoKufiArabic(
                          textStyle: TextStyle(
                            color: _fat7,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Image.asset(
                        "images/pngegg.png",
                        fit: BoxFit.cover,
                        height: 120,
                      ),
                    ],
                  ),
                  height: 120,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _8am2,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 90,
                    mainAxisSpacing: 30,
                  ),
                  itemCount: icons.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: functions[index],
                      child: Container(
                        decoration: BoxDecoration(
                          color: _8am2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icons[index],
                            SizedBox(height: 10),
                            Text(
                              texts[index],
                              style: GoogleFonts.notoKufiArabic(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  color: _fat7,
                                ),
                              ),
                            ),
                          ],
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