import 'package:flutter/material.dart';
import 'package:srm_gpt/signup.dart';
import 'package:srm_gpt/user.dart';

void main() {
  runApp(const LoginPages());
}

class LoginPages extends StatelessWidget {
  const LoginPages({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          Landing(),
        ]),
      ),
    );
  }
}

class Landing extends StatelessWidget {
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
                top: 0,
                child: Container(
                  width: 390,
                  height: 844,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 50,
                top: 72,
                child: Image.asset(
                  'images/logo.png',
                  width: 250.0, // Set the width as needed
                  height: 250.0,
                  alignment: Alignment.center,// Set the height as needed
                ),
              ),
              Positioned(
                left: 32,
                top: 372,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF9A84F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: SizedBox(
                    width: 270,
                    height: 50,
                    child: Center(
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 48,
                top: 245,
                child: Container(
                  width: 295,
                  height: 63.86,
                  child: Stack(children: [
                  ]),
                ),
              ),
              Positioned(
                left: -63,
                top: 541,
                child: Container(
                  width: 345,
                  height: 345,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/5.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 58,
                top: 317,
                child: SizedBox(
                  width: 264,
                  height: 29,
                  child: Text(
                    'Your perfect classmate!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF464646),
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 32,
                top: 448,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignUps(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF0BA38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: SizedBox(
                    width: 270,
                    height: 50,
                    child: Center(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
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
