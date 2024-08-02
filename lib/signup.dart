import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:srm_gpt/user.dart';
import 'package:srm_gpt/user.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const SignUps());
}

class SignUps extends StatelessWidget {
  const SignUps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(
          children: [
            SignUp(),
          ],
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController collegeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();



// ... Your existing code ...
  void signUp() async {
    final String apiUrl = "http://192.168.221.96:8000/signup/";

    // Get user details from controllers
    String username = fullNameController.text;
    String password = passwordController.text;

    try {
      // Make a POST request to the signup API
      String jsonBody = json.encode({
        'username': username,
        'password': password,
      });
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Set the content type
        },
        body: jsonBody,
      );

      // Check if the signup was successful based on the API response
      if (response.statusCode == 200) {
        // Redirect to UserPage if signup is successful
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserPage(),
          ),
        );
      } else {
        // Display a pop-up message in case of failure
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Signup Failed'),
              content: Text('There was an error during signup. Please try again.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle any exceptions that may occur during the HTTP request
      print('Error during signup: $e');
    }
  }


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
                  decoration: BoxDecoration(color: Color(0xFF9A84F5)),
                ),
              ),
              Positioned(
                left: 30,
                top: 84,
                child: SizedBox(
                  width: 327,
                  height: 57,
                  child: Text(
                    'Sign-up',
                    style: TextStyle(
                      color: Color(0xFFF9CF6A),
                      fontSize: 43,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 34,
                top: 188,
                child: Container(
                  width: 290,
                  height: 48,
                  child: TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      filled: false,
                      fillColor: Colors.white,
                      labelText: 'Full Name',
                      labelStyle: TextStyle(
                        color: Color(0xFFF9CF6A),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 34,
                top: 248,
                child: Container(
                  width: 290,
                  height: 48,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black,style: BorderStyle.solid),
                      ),
                      filled: false,
                      fillColor: Colors.white,
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Color(0xFFF9CF6A),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 34,
                top: 308,
                child: Container(
                  width: 290,
                  height: 48,
                  child: TextFormField(
                    controller: collegeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: false,
                      fillColor: Colors.white,
                      labelText: 'College/Institution/School',
                      labelStyle: TextStyle(
                        color: Color(0xFFF9CF6A),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 34,
                top: 368,
                child: Container(
                  width: 290,
                  height: 48,
                  child: TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: false,
                      fillColor: Colors.white,
                      labelText: 'Age',
                      labelStyle: TextStyle(
                        color: Color(0xFFF9CF6A),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 34,
                top: 428,
                child: Container(
                  width: 290,
                  height: 48,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: false,
                      fillColor: Colors.white,
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Color(0xFFF9CF6A),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 113,
                top: 538,
                child: SizedBox(
                  width: 130,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF9CF6A),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF9A84F5),
                        fontSize: 28,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w700,
                        height: 0,
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
