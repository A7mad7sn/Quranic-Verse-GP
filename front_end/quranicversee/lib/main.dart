import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:http/http.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:quranicversee/home_page.dart';
import 'package:quranicversee/quran_main.dart';
import 'package:quranicversee/search_page.dart';
import 'package:quranicversee/settings.dart';
import 'package:quranicversee/voice_search_page.dart';
import 'package:quranicversee/model_page.dart';
import 'package:quranicversee/home_page.dart';
import 'package:quranicversee/prayer_timesPage.dart';
import 'ayah_info.dart';
import 'constant.dart';
import 'functions.dart';
import 'index.dart';
import 'package:quranicversee/qibla_page.dart';

void main() {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'basic channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            importance: NotificationImportance.High)
      ],
      debug: true);
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
  String _gregorianDate = '';
  String _hijriDate = '';
  String _time = '';

  String locationMessage = "";
  String URL = "http://api.aladhan.com/v1/timings/";

  Position? _currentPosition;
  List<String> prayerTimings = [];

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAlowed) {
      if (!isAlowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
    _updateDateTime();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
    _getCurrentLocation().then((_) {
      _updateURL();
      _fetchPrayerTimings().then((_) {
        _checkAndNotify();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await readJson();
      await getSettings();
    });
  }

  int index = 0; // Default to the first tab

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.settings, size: 30),
  ];

  final pages = [
    HomePage(),
    Settings(), // Assuming you have a SettingsPage or you can create one
  ];

  void _updateDateTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final HijriCalendar hijriDate = HijriCalendar.fromDate(now);

    setState(() {
      _gregorianDate = formatter.format(now);
      // Formatting Gregorian date with Arabic month name
      _hijriDate =
          '${toArabicNumbers(hijriDate.hDay.toString())}-${getHijriMonthName(hijriDate.hMonth)}-${toArabicNumbers(hijriDate.hYear.toString())}';
      _time = DateFormat('HH:mm').format(now);
    });
  }

  Future<void> _checkAndNotify() async {
    List<String> prayerNames = [
      "الفجر",
      "الشروق",
      "الظهر",
      "العصر",
      "المغرب",
      "العشاء"
    ];
    int counter = 0;
    setState(() {
      _time = DateFormat('HH:mm').format(DateTime.now());
      for (var prayerTime in prayerTimings) {
        if (_time == prayerTime) {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 10,
                  channelKey: 'basic channel',
                  title: 'اذان ${prayerNames[counter]}',
                  body: 'حان الان موعد اذان ${prayerNames[counter]}'));
        }
        counter++;
      }
    });
  }

  void _updateTime() {
    setState(() {
      _time = DateFormat('HH:mm').format(DateTime.now());
    });
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

  void _updateURL() {
    setState(() {
      URL =
          "http://api.aladhan.com/v1/timings/${_gregorianDate}?latitude=${_currentPosition?.latitude}&longitude=${_currentPosition?.longitude}&method=5";
    });
    print(URL);
  }

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
        child: pages[index], // Display the selected page
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.amber.shade50),
        ),
        child: CurvedNavigationBar(
          items: items,
          index: index,
          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
          backgroundColor: Color(0xffe0d2b4),
          color: Color(0xff195e59),
          animationCurve: Curves.ease,
          animationDuration: Duration(milliseconds: 300),
          buttonBackgroundColor: Color(0xffe0d2b4),
        ),
      ),
    );
  }
}
