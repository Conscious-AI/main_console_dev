import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:create_atom/create_atom.dart';

import 'SplitWidget.dart';
import 'CommandSection.dart';
import 'LogSection.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(context) {
    return Center(
      child: Atom(
        size: 75,
        nucleusColor: Colors.white,
        orbitsColor: Colors.white,
        electronsColor: Colors.white,
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _showExitDialog(context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit Main Console ?'),
          actions: <Widget>[
            FlatButton(
              color: Colors.grey[900],
              child: Text('Yes'),
              onPressed: () {
                Process.killPid(COpsProcess.pid);
                // Temporary workaround for closing the release app
                debugger();
                exit(0);
              },
            ),
            FlatButton(
              color: Colors.grey[900],
              child: Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        title: Text("Main Control"),
        actions: [
          IconButton(
            tooltip: "Settings",
            hoverColor: Colors.blue,
            splashRadius: 20.0,
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            tooltip: "Exit",
            hoverColor: Colors.red,
            splashRadius: 20.0,
            icon: Icon(Icons.close),
            onPressed: () => _showExitDialog(context),
          ),
        ],
      ),
      body: Split(
        axis: Axis.vertical,
        initialFirstFraction: 0.4,
        dragIndicatorColor: Colors.white,
        firstChild: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: CommandView(),
        ),
        secondChild: Split(
          axis: Axis.vertical,
          dragIndicatorColor: Colors.white,
          firstChild: Container(
            alignment: Alignment.center,
            color: Colors.black,
            child: SingleChildScrollView(child: const _Loader()),
          ),
          secondChild: Container(
            alignment: Alignment.center,
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
              child: LogView(),
            ),
          ),
        ),
      ),
    );
  }
}
