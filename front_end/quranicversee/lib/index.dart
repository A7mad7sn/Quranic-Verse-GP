import 'package:flutter/material.dart';
import 'package:quranicversee/search_page.dart';
import 'arabic_sura_number.dart';
import 'mic_button.dart';
import 'surah_builder.dart';
import 'constant.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

//الصفحة الرئيسية اللى بيتعرض فيها اسماء السور
class _IndexPageState extends State<IndexPage> {
  Color _8am2 = Color(0xff195e59);
  Color _fat7 = Color(0xffe0d2b4);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'إذهب إلى العلامة المرجعية',
        backgroundColor: const Color.fromARGB(255, 0, 77, 64),
        onPressed: () async {
          fabIsClicked = true;
          if (await readBookmark() == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SurahBuilder(
                          arabic: quran[0],
                          sura: bookmarkedSura - 1,
                          suraName: arabicName[bookmarkedSura - 1]['name'],
                          ayah: bookmarkedAyah,
                          highlighted: true,
                        )));
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: _8am2,
                content: Text(
                  "لا توجد علامة مرجعية",
                  style: TextStyle(color: _fat7, fontSize: 20),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
        child: const Icon(
          Icons.bookmark,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        leading: MicButton(),
        actions: [
          IconButton(
            color: _fat7,
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_right_outlined,
              color: _fat7,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        centerTitle: true,
        title: const Text(
          "القرآن الكريم",
          //"Quran",
          style: TextStyle(
            fontFamily: 'quran',
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: const Color(0xffe0d2b4),
          ),
        ),
        backgroundColor: const Color(0xff195e59),
      ),
      body: FutureBuilder(
        future: readJson(),
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return indexCreator(snapshot.data, context);
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }

  Container indexCreator(quran, context) {
    return Container(
      color: const Color(0xffe0d2b4),
      child: ListView(
        children: [
          for (int i = 0; i < 114; i++)
            Container(
              color: const Color(0xffe0d2b4),
              child: TextButton(
                child: Row(
                  children: [
                    ArabicSuraNumber(i: i),
                    const SizedBox(
                      width: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Text(
                      arabicName2[i]['name'],
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black87,
                          fontFamily: 'quran',
                          shadows: [
                            Shadow(
                              offset: Offset(.5, .5),
                              blurRadius: 1.0,
                              color: Color.fromARGB(255, 130, 130, 130),
                            )
                          ]),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                onPressed: () {
                  fabIsClicked = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SurahBuilder(
                              arabic: quran[0],
                              sura: i,
                              suraName: arabicName[i]['name'],
                              ayah: 0,
                            )),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
