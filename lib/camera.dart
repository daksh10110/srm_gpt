import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:srm_gpt/scan.dart'; // Import your ScanPage if it's in a separate file

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  String scannedText = '';

  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((x) => setState(() {}));
  }

  static int OCR_CAM = FlutterMobileVision.CAMERA_BACK;

  Future<void> _read() async {
    List<OcrText> texts = [];

    try {
      texts = await FlutterMobileVision.read(
        multiple: true,
        camera: OCR_CAM,
        waitTap: false,
        preview: FlutterMobileVision.PREVIEW,
      );
      if (texts.isNotEmpty) {
        setState(() {
          scannedText = texts.map((text) => text.value).join('\n');
        });
      }
    } on Exception {
      texts.add(new OcrText('Failed to recognize text.'));
    }
    if (!mounted) return;
    setState(() {});
  }

  void backPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: scannedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Text copied to clipboard'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backPressed(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your App Title'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ScanPage()),
              );
            },
          ),
        ),
        body: Card(
          color: Colors.grey.shade700,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: _read,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                    ),
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Scan Using Camera",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  scannedText,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (scannedText.isNotEmpty) {
                      copyToClipboard();
                    }
                  },
                  child: Text('Copy to Clipboard'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
