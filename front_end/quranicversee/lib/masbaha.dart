import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class MasbahaPage extends StatefulWidget {
  MasbahaPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MasbahaPageState();
}

Color _fat7 = Color(0xffe8e0d5);
Color _8am2 = Color(0xff195e59);

class MasbahaPageState extends State<MasbahaPage> {
  int _counter = 0;
  final TextEditingController _textController = TextEditingController();
  String? _displayText;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _submitText() {
    setState(() {
      _displayText = _textController.text;
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          'المسبحة',
          style: GoogleFonts.notoKufiArabic(
            textStyle: TextStyle(
                color: _fat7, fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _fat7,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_displayText == null) ...[
                          SizedBox(
                            width: 200,
                            child: TextFormField(
                              controller: _textController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffe8e0d5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey, // normal border color
                                    width: 2, // normal border width
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color:
                                        _8am2, // color of the border when not focused
                                    width:
                                        5, // thickness of the border when not focused
                                  ),
                                ),
                                labelText: 'ادخل النص',
                                labelStyle: GoogleFonts.notoKufiArabic(
                                  textStyle: TextStyle(
                                    fontSize: 16, // font size
                                    color: Colors.black, // font color
                                  ),
                                ),
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                              ),
                              textDirection: TextDirection.rtl,
                              onFieldSubmitted: (value) => _submitText(),
                            ),
                          ),
                        ] else ...[
                          Text(
                            _displayText!,
                            style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(
                          height: 50,
                        ),
                        Icon(
                          FlutterIslamicIcons.solidTasbihHand,
                          size: 300,
                          color: _8am2,
                        ),
                        SizedBox(height: 20),
                        Text(
                          '$_counter',
                          style: TextStyle(
                            fontSize: 50,
                            color: _8am2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            IconButton(
                              onPressed: _incrementCounter,
                              icon: Icon(
                                Icons.add,
                                size: 120,
                                color: _8am2,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            IconButton(
                              onPressed: _resetCounter,
                              icon: Icon(
                                Icons.restart_alt,
                                size: 100,
                                color: _8am2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
