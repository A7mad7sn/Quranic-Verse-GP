import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quranicversee/functions.dart';

import 'constant.dart';

List<List<dynamic>> listData = [];
Future<void> load_Data() async {
  final _rawData = await rootBundle.loadString("data/Tafseer.csv");
  listData = const CsvToListConverter().convert(_rawData);
}

Future<Map<String, dynamic>> get_ayah_info(String ayah, bool isIndex) async {
  Map<String, String> ayahInfo = {
    'ayah': ayah,
    'surah': '؟',
    'tafsir': '؟',
    'number': '؟'
  };

  if (isIndex) {
    int index = int.parse(ayah);
    ayahInfo = {
      'ayah': '${listData[index][3]}',
      'surah': all_Chapters[listData[index][1] - 1],
      'tafsir': '${listData[index][4]}',
      'number': toArabicNumbers(listData[index][2].toString()),
    };

    return ayahInfo;
  } else {
    for (var row in listData) {
      if (row[3] == ayah || row[5] == ayah) {
        ayahInfo = {
          'ayah': '${row[3]}',
          'surah': all_Chapters[row[1] - 1],
          'tafsir': '${row[4]}',
          'number': toArabicNumbers(row[2].toString()),
        };

        return ayahInfo;
      }
    }
  }
  return ayahInfo;
}

Future<Map<String, dynamic>> get_tafsir_info(String tafsir) async {
  Map<String, String> tafsirInfo = {
    'ayah': '؟',
    'surah': '؟',
    'tafsir': tafsir,
    'number': '؟'
  };

  for (var row in listData) {
    if (row[4] == tafsir) {
      tafsirInfo = {
        'ayah': '${row[3]}',
        'surah': all_Chapters[row[1] - 1],
        'tafsir': '${row[4]}',
        'number': toArabicNumbers(row[2].toString()),
      };
      break;
    }
  }
  return tafsirInfo;
}

List<String> get_all_ayat() {
  List<String> all_ayat = [];
  for (var row in listData) {
    all_ayat.add(row[5]);
  }
  return all_ayat;
}

List<String> get_all_tafsir() {
  List<String> all_tafsir = [];
  for (var row in listData) {
    all_tafsir.add(row[4]);
  }
  return all_tafsir;
}

Widget view_ayah_info(Map<String, dynamic> info) {
  var c1 = Colors.red;
  var c2 = Colors.black;
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align children to the end
      textDirection: TextDirection
          .rtl, // Right-to-left text direction for the whole column
      children: [
        Container(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'الآية : ',
                  style: TextStyle(color: c1), // Color for the label
                ),
                TextSpan(
                  text: info['ayah'],
                  style: TextStyle(color: c2), // Color for the ayah text
                ),
              ],
            ),
            textDirection:
                TextDirection.rtl, // Right-to-left text direction for this text
            textAlign: TextAlign.right,
          ),
        ),
        Container(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'السورة : ',
                  style: TextStyle(color: c1), // Color for the label
                ),
                TextSpan(
                  text: info['surah'],
                  style: TextStyle(color: c2), // Color for the surah text
                ),
              ],
            ),
            textDirection:
                TextDirection.rtl, // Right-to-left text direction for this text
            textAlign: TextAlign.right,
          ),
        ),
        Container(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'رقم الآية : ',
                  style: TextStyle(color: c1), // Color for the label
                ),
                TextSpan(
                  text: info['number'],
                  style: TextStyle(color: c2), // Color for the number text
                ),
              ],
            ),
            textDirection:
                TextDirection.rtl, // Right-to-left text direction for this text
            textAlign: TextAlign.right,
          ),
        ),
        Container(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'التفسير المختصر : ',
                  style: TextStyle(color: c1), // Color for the label
                ),
                TextSpan(
                  text: info['tafsir'],
                  style: TextStyle(color: c2), // Color for the tafsir text
                ),
              ],
            ),
            textDirection:
                TextDirection.rtl, // Right-to-left text direction for this text
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}

Widget build_info_Dialog(var info, context) {
  return AlertDialog(
    title: const Text('معلومات الآية',
        textDirection:
            TextDirection.rtl, // Right-to-left text direction for this text
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blue)),
    content: view_ayah_info(info),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('غلق'),
      ),
    ],
  );
}
