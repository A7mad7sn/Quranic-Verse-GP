import 'package:flutter/material.dart';
import 'arabic_sura_number.dart';
import 'mydrawer.dart';
import 'settings.dart';
import 'surah_builder.dart';
import 'constant.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

//الصفحة الرئيسية اللى بيتعرض فيها اسماء السور
class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Go to bookmark',
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
          }
        },
        child: const Icon(
          Icons.bookmark,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
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
        /*leading: IconButton(
            tooltip: 'Font Size',
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
          )*/),
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
                      arabicName[i]['name'],
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
