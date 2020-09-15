import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'Utility.dart';
import 'DBHelper.dart';
import 'Photo.dart';
import 'dart:async';

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
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'ホームページ'),
        '/show': (context) => ShowPage(title: 'データベースの中身')
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ShowPage extends StatefulWidget {
  ShowPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ShowPageState createState() => _ShowPageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();
  DBHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  _pickImageFromGallery() {
    final picker = ImagePicker();
    picker.getImage(source: ImageSource.gallery).then((imgFile) async {
      if (imgFile != null) {
        String imgString = Utility.base64String(await imgFile.readAsBytes());
        Photo photo = Photo(0, imgString);
        dbHelper.save(photo);
      }
    });
  }

  _pickImageFromCamera() {
    final picker = ImagePicker();
    picker.getImage(source: ImageSource.camera).then((imgFile) async {
      if (imgFile != null) {
        String imgString = Utility.base64String(await imgFile.readAsBytes());
        Photo photo = Photo(0, imgString);
        dbHelper.save(photo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = 230.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: buttonWidth,
              child: RaisedButton.icon(
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                label: Text("カメラで撮る"),
                onPressed: () {
                  _pickImageFromCamera();
                },
                color: Colors.green,
                textColor: Colors.white,
              ),
            ),
            SizedBox(
              width: buttonWidth,
              child: RaisedButton.icon(
                icon: Icon(
                  Icons.folder_open,
                  color: Colors.white,
                ),
                label: Text("フォルダから取り込む"),
                onPressed: () {
                  _pickImageFromGallery();
                },
                color: Colors.green,
                textColor: Colors.white,
              ),
            ),
            SizedBox(
              width: buttonWidth,
              child: RaisedButton.icon(
                icon: Icon(
                  Icons.storage,
                  color: Colors.white,
                ),
                label: Text("データベースの中身を表示"),
                onPressed: () {
                  Navigator.pushNamed(context, '/show');
                },
                color: Colors.green,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowPageState extends State<ShowPage> {
  Future<File> imageFile;
  Image image;
  DBHelper dbHelper;
  List<Photo> images;

  @override
  void initState() {
    super.initState();
    images = [];
    dbHelper = DBHelper();
    refreshImages();
  }

  _deleteDataInDB() {
    dbHelper.deleteDataInDB();
  }

  refreshImages() {
    dbHelper.getPhotos().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: images.map((photo) {
          return Utility.imageFromBase64String(photo.photo_data);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteDataInDB();
              refreshImages();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: gridView(),
            ),
          ],
        ),
      ),
    );
  }
}
