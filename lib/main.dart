import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<File> imageFile;
  File _image;
  String result = '';
  TextDetector textDetector;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textDetector = GoogleMlKit.vision.textDetector();
  }

  doTextRecognition() async {
    final inputImage = InputImage.fromFile(_image);
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);
    String text = recognisedText.text;
    setState(() {
      result = text;
    });
    for (TextBlock block in recognisedText.blocks) {
      final Rect rect = block.rect;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      if (_image != null) {
        doTextRecognition();
      }
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
      if (_image != null) {
        doTextRecognition();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Image to Text Recognition"),
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(
                width: 100,
              ),
              Container(
                height: 280,
                width: 250,
                margin: EdgeInsets.only(top: 70),
                padding: EdgeInsets.only(left: 28, bottom: 5, right: 18),
                child: SingleChildScrollView(
                    child: Text(
                  '$result',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: 'solway', fontSize: 10),
                )),
              ),
              RaisedButton(
                onPressed: _imgFromGallery,
                child: Text("Pick Image to recognize Text"),
              ),
              if (_image != null)
                Container(
                  child: Image.file(
                    _image,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              // Container(margin:EdgeInsets.only(top:300,right: 80),child: Center(
              //
              // )),
            ],
          ),
        ),
      ),
    );
  }
}
