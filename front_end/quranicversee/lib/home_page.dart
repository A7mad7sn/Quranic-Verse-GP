import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:quranicversee/model_page.dart';
import 'package:quranicversee/quran_main.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<IconData> icons = [
    FlutterIslamicIcons.solidQuran2,
    FlutterIslamicIcons.tasbih2,
    FlutterIslamicIcons.qibla,
    FlutterIslamicIcons.solidQuran
  ];

  List<String> texts = ["القران الكريم", "المسبحة", "القبلة", "تفسير"];

  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff195e59),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // SizedBox(height: 10,),
            Text(
              "Quranic Verse",
              style: GoogleFonts.elMessiri(
                textStyle: TextStyle(
                  color: Color(0xffe0d2b4),
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
            Image.asset("images/awyyy-01.png"),
            // Adjust spacing as needed
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffe0d2b4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Container(padding: EdgeInsets.all(10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Explore Features",
                            style: GoogleFonts.elMessiri(
                              textStyle: TextStyle(
                                color: Color(0xff195e59),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("View All",
                              style: GoogleFonts.elMessiri(
                                textStyle: TextStyle(
                                  color: Color(0xff195e59),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Color(0xff195e59),
                            child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: icons.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 295.0,
                                crossAxisSpacing: 120.0,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.all(5),
                                  child: InkWell(
                                    onTap: () {
                                      if (index == 0) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    QuranApp()));
                                      } else if (index == 3) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ModelPage()));
                                      }
                                      // Handle tap on the circular container
                                    },
                                    child: ClipOval(
                                      child: Container(
                                        height: 200,
                                        width: 150,
                                        color: Colors.green[50],
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              icons[index],
                                              color: Colors.black,
                                              size: 50,
                                            ),
                                            SizedBox(
                                                height:
                                                    10), // Adjust as needed for spacing
                                            Text(
                                              texts[
                                                  index], // Add your text here
                                              style: GoogleFonts.notoKufiArabic(
                                                textStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
