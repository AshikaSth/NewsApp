





import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 10),(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen() ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Image.asset('images/splash_pic.jpg',
            fit: BoxFit.cover,
              width: size.width * .98,
              height: size.height * .8,
            ),
            SizedBox( height: size.height  * .04,),
            Text('TOP HEADLINES', style: GoogleFonts.anton(letterSpacing: .6, color: Colors.grey.shade700),),
            SizedBox( height: size.height  * .04,),
            SpinKitChasingDots(
              color: Colors.blue,
              size: 40,
            )
          ]
        ),
      )  
    );
  }
}
