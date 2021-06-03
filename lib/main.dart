import 'package:flutter/material.dart';
import './GMapsPlusLocation.dart';
void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: new MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Maps App"),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: new Material(
        color: Colors.teal,
        child: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.gps_fixed)),
          ],
        ),
      ),
      body: new TabBarView(controller: controller, children: <Widget>[
        new MapSample(),
      ]),
    );
  }
}