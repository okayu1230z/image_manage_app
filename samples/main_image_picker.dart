import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future _takePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Container(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(_image),
          ),
          RaisedButton.icon(
            icon: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            label: Text("カメラで撮る"),
            onPressed: _takePicture,
            color: Colors.green,
            textColor: Colors.white,
          ),
          RaisedButton.icon(
            icon: Icon(
              Icons.folder_open,
              color: Colors.white,
            ),
            label: Text("フォルダから取り込む"),
            onPressed: _getImage,
            color: Colors.green,
            textColor: Colors.white,
          ),
        ]),
      ),
    );
  }
}
