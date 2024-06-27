import 'dart:async';
import 'ayah_info.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';

class SurahBuilder extends StatefulWidget {
  final sura;
  final arabic;
  final suraName;
  int ayah;
  bool highlighted;

  SurahBuilder(
      {Key? key,
      this.sura,
      this.arabic,
      this.suraName,
      required this.ayah,
      this.highlighted = false})
      : super(key: key);

  @override
  _SurahBuilderState createState() => _SurahBuilderState();
}

class _SurahBuilderState extends State<SurahBuilder> {
  bool view = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 7), () {
      if (mounted) {
        setState(() {
          widget.highlighted = false;
        });
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) => jumbToAyah());
  }

  jumbToAyah() {
    if (fabIsClicked) {
      itemScrollController.scrollTo(
          index: widget.ayah,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOutCubic);
    }
    // fabIsClicked = false;
  }

  Row verseBuilder(int index, previousVerses) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.arabic[index + previousVerses]['aya_text'],
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: arabicFontSize,
                  fontFamily: arabicFont,
                  color: widget.highlighted == true
                      ? index == widget.ayah
                          ? const Color.fromARGB(255, 200, 0, 0)
                          : const Color.fromARGB(196, 0, 0, 0)
                      : const Color.fromARGB(196, 0, 0, 0),
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // بيعرض السورة على انها سترينج واحد
  SafeArea SingleSuraBuilder(LenghtOfSura) {
    String fullSura = '';
    int previousVerses = 0;
    if (widget.sura + 1 != 1) {
      for (int i = widget.sura - 1; i >= 0; i--) {
        previousVerses = previousVerses + noOfVerses[i];
      }
    }

    if (!view) {
      for (int i = 0; i < LenghtOfSura; i++) {
        fullSura += (widget.arabic[i + previousVerses]['aya_text']);
      }
    }

    return SafeArea(
      child: Container(
        color: const Color.fromARGB(255, 253, 251, 240),
        child: view
            ? ScrollablePositionedList.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      (index != 0) || (widget.sura == 0) || (widget.sura == 8)
                          ? const Text('')
                          : const RetunBasmala(),
                      Container(
                        color: index % 2 != 0
                            ? const Color.fromARGB(255, 253, 251, 240)
                            : const Color.fromARGB(255, 253, 247, 230),
                        child: PopupMenuButton(
                            tooltip: '',
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: verseBuilder(index, previousVerses),
                            ),
                            itemBuilder: (context) => [
                                  // Book Mark
                                  PopupMenuItem(
                                    onTap: () {
                                      saveBookMark(widget.sura + 1, index);
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.bookmark_add,
                                          color: Color(0xff195e59),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('علامة مرجعية'),
                                      ],
                                    ),
                                  ),
                                  // aya info
                                  PopupMenuItem(
                                    onTap: () async {
                                      int indexer = index + previousVerses + 1;
                                      var info = await get_ayah_info(
                                          '${indexer}', true);
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            build_info_Dialog(info, context),
                                      );
                                    },
                                    child: const Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.account_tree_outlined,
                                          color:
                                              Color.fromARGB(255, 213, 54, 0),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('معلومات الاية'),
                                      ],
                                    ),
                                  ),
                                ]),
                      ),
                    ],
                  );
                },
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemCount: LenghtOfSura,
              )
            : ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.sura + 1 != 1 && widget.sura + 1 != 9
                                ? const RetunBasmala()
                                : const Text(''),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                fullSura, //mushaf mode
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: mushafFontSize,
                                  fontFamily: arabicFont,
                                  color: const Color.fromARGB(196, 44, 44, 44),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int LengthOfSura = noOfVerses[widget.sura];
    Color _8am2 = Color(0xff195e59);
    Color _fat7 = Color(0xffe0d2b4);
    return MaterialApp(
        debugShowCheckedModeBanner: false, 

      theme: ThemeData(primarySwatch: Colors.yellow),
      home: Scaffold(
        appBar: AppBar(
          actions: [
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
          leading: Tooltip(
            message: 'Mushaf Mode',
            child: TextButton(
              child: const Icon(
                Icons.chrome_reader_mode,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  view = !view;
                });
              },
            ),
          ),
          centerTitle: true,
          title: Text(
            // widget.
            widget.suraName,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'quran',
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ]),
          ),
          backgroundColor: const Color(0xff195e59),
        ),
        body: SingleSuraBuilder(LengthOfSura),
      ),
    );
  }
}

class RetunBasmala extends StatelessWidget {
  const RetunBasmala({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Stack(children: [
      Center(
        child: Text(
          "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
          style: TextStyle(
              fontFamily: 'quran', fontSize: 40, fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
      ),
    ]);
  }
}

void navigateToQuranVerse(
    BuildContext context, int verseNumber, String suraName) {
  suraName = suraName.replaceAll("ياسين", 'يس').replaceAll('أ', 'ا').replaceAll('إ', 'ا');
  int suraIndex = 0;
  if (suraName[suraName.length - 1] == "ه" && suraName != "طه") {
    suraName = '${suraName.substring(0, suraName.length - 1)}ة';
  }

  for (var entry in arabicNameNoTa4kel) {
    if (entry['name'].replaceAll('أ', 'ا').replaceAll('إ', 'ا') == suraName) {
      suraIndex = entry['surah'];
    }
  }
  // Replace this with your actual navigation logic to the Quran widget
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SurahBuilder(
            arabic: quran[0],
            sura: suraIndex - 1,
            suraName: arabicName[suraIndex - 1]['name'],
            ayah: verseNumber - 1,
            highlighted: true,
          )));
  print('Navigating to verse $verseNumber of $suraName in the Quran...');
}
