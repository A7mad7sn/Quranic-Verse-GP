import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadith/hadith.dart';

class SingleBookPage extends StatefulWidget {
  final int bookNum;
  final String bookName;
  SingleBookPage({Key? key, required this.bookNum, required this.bookName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SingleBookPageState();
}

class SingleBookPageState extends State<SingleBookPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> allHadiths = [];
  Color _8am2 = Color(0xff195e59);
  Color _fat7 = Color(0xffe0d2b4);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    openBook(widget.bookNum);
  }

  Future<void> openBook(int bookNum) async {
    setState(() {
      isLoading = true;
    });
    List<dynamic> hadiths = await getHadiths(Collections.bukhari, bookNum);
    setState(() {
      isLoading = false;
      allHadiths = hadiths;
    });
  }

  String removeEnglishCharsAndNumbers(String input) {
    final regex = RegExp(r'[a-zA-Z0-9</>]');

    String result = input.replaceAll(regex, '');

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _fat7,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: _8am2,
        title: Text(
          widget.bookName,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.elMessiri(
            textStyle: TextStyle(
              fontSize: 30,
              color: _fat7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: (isLoading == true && allHadiths == [])
          ? Center(
              child: Container(
                color: _fat7,
                child: CircularProgressIndicator(
                  color: Color(0xff195e59),
                ),
              ),
            )
          : Container(
              color: _fat7,
              child: ListView.builder(
                itemCount: allHadiths.length,
                itemBuilder: (context, index) {
                  final currentHadith = allHadiths[index];
                  return Card(
                    color: Color(0xff195e59),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        removeEnglishCharsAndNumbers(
                            currentHadith.hadith[1].chapterTitle),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffe0d2b4),
                        ),
                      ),
                      subtitle: Text(
                        '${removeEnglishCharsAndNumbers(currentHadith.hadith[1].body)}\n${currentHadith.hadith[1].grades[0]['grade']}',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
