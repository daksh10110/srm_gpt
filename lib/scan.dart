import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:srm_gpt/main.dart';
import 'package:srm_gpt/flashcard.dart';
import 'package:srm_gpt/notes.dart';

import 'package:srm_gpt/camera.dart';
import 'package:srm_gpt/Home.dart';
import 'package:srm_gpt/upload.dart';
class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(
          children: [
            Home(),
          ],
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {


  const Home({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 764,
                child: Container(
                  width: 390,
                  height: 80,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF7F7F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 19,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.home), // Replace with the first icon you want
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        color: Colors.grey,
                      ),
                      IconButton(
                        icon: Icon(Icons.note), // Replace with the second icon you want
                        color : Colors.grey,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NotesPage(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.camera), // Replace with the third icon you want
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ScanPage(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.person), // Replace with the fourth icon you want
                        color: Colors.grey,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FlashCard(),
                            ),
                          );

                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 16,
                right: 10,
                child: Container(
                  height: 149,
                  decoration: ShapeDecoration(
                    color: Color(0xFF9A83F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 29,
                top: 40,
                child: SizedBox(
                  width: 177,
                  height: 105,
                  child: Text(
                    'Scan for the magic!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 178,
                top: 0,
                child: Container(
                  width: 215,
                  height: 215,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/APP.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 683,
                child: SizedBox(
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: ()  {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Camera(),
                        ),
                      );

                      // Place the function you want to execute when the button is pressed here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF796FE1),// Button background color
                      elevation: 0, // Button elevation (shadow)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Button border radius
                      ),
                    ),
                  child: Text(
                    'Scan now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),

              ),
              Positioned(
                left: 200,
                top: 683,
                child: SizedBox(
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: ()  {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UploadPage(),
                        ),
                      );

                      // Place the function you want to execute when the button is pressed here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF796FE1),// Button background color
                      elevation: 0, // Button elevation (shadow)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Button border radius
                      ),
                    ),
                    child: Text(
                      'Upload',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                ),

              ),
              Positioned(
                left: 45,
                top: 588,
                child: SizedBox(
                  width: 313,
                  height: 54,
                  child: Text(
                    'Simply scan the text in front of you and let the magic happen',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF494848),
                      fontSize: 18,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -58,
                top: 196,
                child: Opacity(
                  opacity: 0.65,
                  child: Container(
                    width: 437,
                    height: 437,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/APP (1).png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


