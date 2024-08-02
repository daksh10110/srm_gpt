import 'dart:math';

import 'package:flutter/material.dart';
import 'package:srm_gpt/Home.dart';
import 'package:srm_gpt/main.dart';
import 'package:srm_gpt/notes.dart';
import 'package:srm_gpt/scan.dart';
import 'package:srm_gpt/slidingwindow.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Explain extends StatelessWidget {
  const Explain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          Explains(),
        ]),
      ),
    );
  }
}

class Explains extends StatefulWidget {
  @override
  _ExplainsState createState() => _ExplainsState();
}

class _ExplainsState extends State<Explains> {
  bool isMenuOpen = false;
  String cardText = 'Type to start chatting';
  TextEditingController textEditingController = TextEditingController();
  String? explanationOutput; // Variable to store the output
  List<String> chatHistory = []; // List to store chat history

  void fetchExplanation() async {
    String text = textEditingController.text;

    // Call the API function
    explanationOutput = await getExplanation(text);
    explanationOutput = explanationOutput?.trimLeft();
    // Add user input and API response to chat history
    chatHistory.add('User Input: $text');
    chatHistory.add('API Response: ${explanationOutput ?? ""}');

    // Update the card text
    updateCardText();

    // Clear the content of the textEditingController
    textEditingController.clear();
  }

// Function to update the text
  void updateCardText() {
    setState(() {
      // Combine the chat history into a single string
      cardText = chatHistory.join('');
    });
  }

  void closeWindow() {
    // Toggle the isMenuOpen state to close the window
    setState(() {
      isMenuOpen = false;
    });
  }
  void toggleStatus(){
    setState(() {
      isMenuOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sliding Icon Button

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
                        color: Colors.grey,
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
                        color: Colors.grey,
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
                              builder: (context) => Explain(),
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
                top: 40,
                right: 10,
                child: Container(
                  height: 149,
                  decoration: ShapeDecoration(
                    color: Color(0xff3190cf),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 29,
                top: 74,
                child: SizedBox(
                  width: 177,
                  height: 105,
                  child: Text(
                    'Explanation',
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
                top: 20,
                child: Container(
                  width: 215,
                  height: 215,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/6.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 683,
                right: 10,
                child: Row(
                    children: [
                      Container(
                        width: 340,
                        height: 54,
                        decoration: ShapeDecoration(
                          color: Color(0xff3190cf).withOpacity(0.2),

                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color(0xff3190cf)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(width: 10, color: Colors.black)
                                  ),
                                  hintText: 'Enter text',
                                  hintStyle: TextStyle(color: Color(0xff3190cf)),
                                ),
                                style: TextStyle(color: Color(0xff3190cf)),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                fetchExplanation();
                              },
                              child: Icon(Icons.send_sharp),
                              style: ElevatedButton.styleFrom(
                                // primary: Colors.white,
                                // onPrimary: Colors.black,
                                  backgroundColor: Color(0xff3190cf).withOpacity(0.7),
                                  shape: CircleBorder(),
                                  fixedSize: Size(30, 30)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                ),
              ),
              Positioned(
                left: 20,
                top: 220,
                right: 20,
                child: Container(
                  width: 260,
                  height: 450,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0),
                  ),
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: chatHistory.length,
                      itemBuilder: (context, index) {
                        bool isUserInput = chatHistory[index].startsWith('User');
                        return Align(
                          alignment: isUserInput ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUserInput ? Color(0xff3190cf) : Color(0xff3190cf).withOpacity(0.7),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomRight: isUserInput ? Radius.circular(0) : Radius.circular(20),
                                bottomLeft: isUserInput ? Radius.circular(20) : Radius.circular(0),
                              ),
                            ),
                            child: Text(
                              chatHistory[index].substring(isUserInput ? 5 : 4),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),


              Positioned(
                top: 0, // Adjust the top value to position the button
                left: 10, // Adjust the right value to position the button
                child: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.menu),
                  onPressed: toggleStatus,
                ),
              ),
              SlidingWindow(
                  isMenuOpen: isMenuOpen,
                onClosePressed: closeWindow,
              ),
            ],
          ),
        ),
      ],
    );
  }
}



Future<String?> getExplanation(String text) async {
  final String apiUrl = "http://192.168.221.96:8000/process/";
  int randomInt = Random().nextInt(99999);
  try {
    String jsonBody = json.encode({
      'type': 'explain_like_im_five',
      'text': text,
      'id':randomInt,
    });
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json', // Set the content type
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      // Parse the response and extract the output
      Map<String, dynamic> data = json.decode(response.body);
      String output = data["result"];

      // Return the output
      return output;
    } else {
      // Handle API error, return null or throw an exception
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Handle any exceptions that may occur during the HTTP request
    print('Error: $e');
    return null;
  }
}
