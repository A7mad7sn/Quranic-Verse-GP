import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:hadith/hadith.dart';
import 'package:quranicversee/single_book_page.dart';

class HadithPage extends StatefulWidget {
  HadithPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HadithPageState();
}

class HadithPageState extends State<HadithPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> allBooks = [];
  bool isLoading = true;
  @override
  void initState() {
    load_Hadith_Data();
    super.initState();
  }

  void load_Hadith_Data() async {
    setState(() {
      isLoading = true;
    });
    allBooks = await getBooks(Collections.bukhari);
    setState(() {
      isLoading = false;
    });
  }

  Color _8am2 = Color(0xff195e59);
  Color _fat7 = Color(0xffe0d2b4);

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
          'أحاديث شريفة',
          textDirection: TextDirection.rtl,
          style: GoogleFonts.elMessiri(
              textStyle: TextStyle(
                  fontSize: 30, color: _fat7, fontWeight: FontWeight.bold)),
        ),
      ),
      body: (isLoading == true && allBooks == [])
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
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: allBooks.length,
                itemBuilder: (context, index) {
                  final currentBook = allBooks[index];
                  return Card(
                    color: Color(0xff195e59),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleBookPage(
                                bookNum: int.parse(currentBook.bookNumber),
                                bookName: currentBook.book[1].name),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${currentBook.book[1].name}',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffe0d2b4),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'عدد الأحاديث : ${currentBook.numberOfHadith}',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
