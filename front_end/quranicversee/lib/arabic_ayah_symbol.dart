import 'package:flutter/material.dart';
import 'package:quranicversee/to_arabic_numbers.dart';


class ArabicAyahNumber extends StatelessWidget {
  const ArabicAyahNumber({Key? key,required this.i}): super(key: key);
    final int i;


  @override
  Widget build(BuildContext context) {
    return Text("\uFD3E"+(i+1).toString().toArabicNumbers+"\uFD3F", style: const TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontSize: 20,
      shadows: [
        Shadow(
          offset: Offset(0.5, 0.5),
          blurRadius: 1,
          color: Colors.amberAccent,
        ),
      ]
    ),);
  }
}
