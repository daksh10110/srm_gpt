import 'package:flutter/material.dart';
import 'package:srm_gpt/Home.dart';
import 'package:srm_gpt/signup.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
void main() {
  runApp(const UserPage());
}

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(
          children: [
            Login(),
          ],
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Login({super.key});// Import the package for JSON encoding/decoding

  void login(BuildContext context) async {
    final String apiUrl = "http://192.168.221.96:8000/login/";

    // Get user details from controllers
    String username = userIdController.text;
    String password = passwordController.text;

    // Create the JSON payload for the request
    String jsonBody = json.encode({
      'username': username,
      'password': password,
    });

    try {
      // Make a POST request to the login API with the JSON payload
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Set the content type
        },
        body: jsonBody, // Use the JSON payload as the request body
      );

      // Check if the login was successful based on the API response
      if (response.statusCode == 200) {
        // Move to HomePage if login is successful
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        // Display a pop-up message in case of unsuccessful login
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Username or password is incorrect. Please try again.'),
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
      print('Error during login: $e');
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
                  decoration: BoxDecoration(color: Color(0xFF9A83F4)),
                ),
              ),
              Positioned(
                left: 32,
                top: 86,
                child: SizedBox(
                  width: 327,
                  height: 105,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to the ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 43,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: 'game-changer!',
                          style: TextStyle(
                            color: Color(0xFFFFDA82),
                            fontSize: 43,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 92,
                top: 433,
                child: ElevatedButton(
                  onPressed: () {
                    login(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF0BA38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: SizedBox(
                    width: 150,
                    height: 48,
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
                left: -70,
                top: 502,
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
                left: 40,
                top: 252,
                child: SizedBox(
                  width: 280,
                  height: 48,
                  child: TextField(
                    controller: userIdController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF0BA38),
                      labelText: 'User ID',
                      labelStyle: TextStyle(color: Color(0xFFF7F7F7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 40,
                top: 330,
                child: SizedBox(
                  width: 280,
                  height: 48,
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF0BA38),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Color(0xFFF7F7F7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),


              Positioned(
                left: 243,
                top: 25,
                child: Container(
                  width: 133,
                  height: 28.79,
                  child: Stack(children: [
                    // Retain the existing content as is
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
