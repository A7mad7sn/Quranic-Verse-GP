import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblaPage extends StatefulWidget {
  QiblaPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => QiblaPageState();
}

Animation<double>? animation;
AnimationController? _animationController;
double begin = 0.0;

class QiblaPageState extends State<QiblaPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xffe8e0d5),
          body: StreamBuilder(
            stream: FlutterQiblah.qiblahStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: const CircularProgressIndicator());
              }
              final qiblahdirection = snapshot.data;
              animation = Tween(
                      begin: begin,
                      end: (qiblahdirection!.qiblah * (pi / 180) * -1))
                  .animate(_animationController!);
              begin = (qiblahdirection!.qiblah * (pi / 180) * -1);
              _animationController!.forward(from: 0);

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("القبلة",
                        style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                                fontSize: 50,
                                color: Color(0xff195e59),
                                fontWeight: FontWeight.bold))),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                        height: 300,
                        child: AnimatedBuilder(
                          animation: animation!,
                          builder: (context, child) => Transform.rotate(
                            angle: animation!.value,
                            child: Image.asset("images/qibla.png"),
                          ),
                        ))
                  ],
                ),
              );
            },
          )),
    );
  }
}
