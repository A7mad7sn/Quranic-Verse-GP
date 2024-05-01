import 'package:flutter/material.dart';
import 'constant.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "الإعدادات",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color(0xffe0d2b4)
            ),
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: const Color(0xff195e59),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'نظام الايات المتتالية:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  Slider(
                    value: arabicFontSize,
                    min: 20,
                    max: 40,
                    activeColor: const Color.fromARGB(255, 0, 171, 169),
                    onChanged: (value) {
                      setState(() {
                        arabicFontSize = value;
                      });
                    },
                  ),
                  Text(
                    "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                    style: TextStyle(
                        fontFamily: 'quran', fontSize: arabicFontSize),
                    textDirection: TextDirection.rtl,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Divider(),
                  ),
                  const Text(
                    'نظام المصحف:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  Slider(
                    value: mushafFontSize,
                    min: 20,
                    max: 50,
                    activeColor: const Color.fromARGB(255, 0, 171, 169),
                    onChanged: (value) {
                      setState(() {
                        mushafFontSize = value;
                      });
                    },
                  ),
                  Text(
                    "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                    style: TextStyle(
                        fontFamily: 'quran', fontSize: mushafFontSize),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              arabicFontSize = 28;
                              mushafFontSize = 40;
                            });
                            saveSettings();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xff195e59)),
                          child: const Text('إعادة ضبط',
                              style: TextStyle(color: Color(0xffe0d2b4)))),
                      ElevatedButton(
                          onPressed: () {
                            saveSettings();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xff195e59)),
                          child: const Text(
                            'حفظ',
                            style: TextStyle(color: Color(0xffe0d2b4)),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
