import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
        '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/show': (context) => ShowPage(title: 'Show Database Page')
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

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();
  final TextStyle myTextStyle = TextStyle(
    fontSize: 28.0,
    color: Colors.black87,
  );

  void _saveData() async {
    String _path = join(await getDatabasesPath(), "mydb.db");
    String textData = _textController.text;

    Database _database = await openDatabase(_path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS mydb (id INTEGER PRIMARY KEY, text TEXT)");
    });

    await _database.transaction((txn) async {
      await txn.rawInsert('INSERT INTO mydb(text) VALUES("$textData")');
    });

    setState(() {
      _textController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text('保存するテキストを書いてください:'),
          TextField(controller: _textController, style: myTextStyle),
          RaisedButton.icon(
            icon: Icon(
              Icons.storage,
              color: Colors.white,
            ),
            label: Text("データベースに保存"),
            onPressed: _saveData,
            color: Colors.green,
            textColor: Colors.white,
          ),
          RaisedButton.icon(
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
        ]),
      ),
    );
  }
}

class ShowPage extends StatefulWidget {
  ShowPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ShowPageState createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  List<Widget> _items = <Widget>[];

  void _getItems() async {
    List<Widget> _list = <Widget>[];
    String _path = join(await getDatabasesPath(), "mydb.db");

    Database _database = await openDatabase(_path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS mydb (id INTEGER PRIMARY KEY, text TEXT)");
    });

    List<Map> _result = await _database.rawQuery('SELECT * FROM mydb');

    for (Map _item in _result) {
      _list.add(ListTile(
        title: Text(_item['id'].toString()),
        subtitle: Text(_item['text']),
      ));
    }

    setState(() {
      _items = _list;
    });
  }

  @override
  void initState() {
    super.initState();
    _getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _items,
      ),
    );
  }
}
