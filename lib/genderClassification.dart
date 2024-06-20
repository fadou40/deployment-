import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';

class GenderClassification extends StatefulWidget {
  static const String id = 'Trash Classification';

  @override
  _GenderClassificationState createState() => _GenderClassificationState();
}

class _GenderClassificationState extends State<GenderClassification> {
  bool _loading = false;
  bool _interpreterBusy = false;
  bool _pickerActive = false;
  File? _image;
  List<dynamic>? _output;
  late ImagePicker _picker;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    _loading = true;
    loadModel().then((_) {
      setState(() {
        _loading = false;
      });
    });
  }

  Future<void> pickImage() async {
    if (_pickerActive) {
      return;
    }
    _pickerActive = true;

    try {
      final image = await _picker.pickImage(source: ImageSource.camera);

      if (image == null) return;

      setState(() {
        _image = File(image.path);
      });
      await classifyImage(_image!);
    } finally {
      _pickerActive = false;
    }
  }

  Future<void> pickGalleryImage() async {
    if (_pickerActive) {
      return;
    }
    _pickerActive = true;

    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        _image = File(image.path);
      });
      await classifyImage(_image!);
    } finally {
      _pickerActive = false;
    }
  }

  Future<void> classifyImage(File image) async {
    if (_interpreterBusy) {
      print("Interpreter is busy, try again later.");
      return;
    }

    setState(() {
      _interpreterBusy = true;
      _loading = true;
    });

    try {
      final output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 6, // Number of classes in your model
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      setState(() {
        _output = output;
      });
    } on PlatformException catch (e) {
      print("Failed to run model on image: '${e.message}'.");
    } catch (e) {
      print("An unexpected error occurred: $e");
    } finally {
      setState(() {
        _interpreterBusy = false;
        _loading = false;
      });
    }
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/modified_model.tflite', // Updated model file path
        labels: 'assets/gender/labels.txt', // Check if labels path is correct
      );
    } on PlatformException catch (e) {
      print("Failed to load model: '${e.message}'.");
    } catch (e) {
      print("An unexpected error occurred while loading the model: $e");
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.deepOrangeAccent,
          title: Text(
            'Trash Classification',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          centerTitle: false,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.004, 1],
              colors: [Color(0xFF000000), Color(0xFF3d3d3d)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40),
              Center(
                child: Text(
                  'Detect Gender',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: _loading
                    ? Container(
                  width: 250,
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/splash_image.png'),
                      SizedBox(height: 50),
                    ],
                  ),
                )
                    : Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 250,
                        child: _image != null ? Image.file(_image!) : Container(),
                      ),
                      SizedBox(height: 30),
                      _output != null
                          ? Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'It\'s ${_output![0]['label']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: pickImage,
                      child: Text('From Camera'),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: pickGalleryImage,
                      child: Text('From Gallery'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


