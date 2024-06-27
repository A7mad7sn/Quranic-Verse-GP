import 'package:flutter/material.dart';
import 'constant.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color _8am2 = Color(0xff195e59);
  Color _fat7 = Color(0xffe0d2b4);
  TextEditingController _controller =
      TextEditingController(text: numberOfAyat.toString());
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "الإعدادات",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0xffe0d2b4)),
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
                  Row(
                    children: [
                      Expanded(
                        flex:
                            1, // Adjust the flex value to control the space distribution
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _8am2),
                          cursorColor: _8am2,
                          keyboardType: TextInputType.number,
                          controller: _controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _fat7,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _8am2,
                                width: 2,
                              ),
                            ),
                          ),
                          
                          onChanged: (value) {
                            numberOfAyat = int.parse(value);
                          },
                        ),
                      ),
                      Expanded(
                        flex:
                            2, // Adjust the flex value to control the space distribution
                        child: const Text(
                          'عدد الآيات المطلوبة من نموذج مرشد الآيات الذكي:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(
                          width:
                              10), // Add some space between the label and the TextFormField
                      
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Divider(),
                  ),
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
                              
                              numberOfAyat = 2;
                              _controller = TextEditingController(text: '2');
                            });
                            saveSettings();
                            SnackBar(
                              content: Text(
                                'تمت إعادة الضبط',
                                textDirection: TextDirection.rtl,
                              ),
                              duration: Duration(
                                  seconds:
                                      2), // Duration for which the SnackBar will be visible
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff195e59)),
                          child: const Text('إعادة ضبط',
                              style: TextStyle(color: Color(0xffe0d2b4)))),
                      ElevatedButton(
                          onPressed: () {
                            saveSettings();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'تم حفظ التغيرات',
                                  textDirection: TextDirection.rtl,
                                ),
                                duration: Duration(
                                    seconds:
                                        2), // Duration for which the SnackBar will be visible
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff195e59)),
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
