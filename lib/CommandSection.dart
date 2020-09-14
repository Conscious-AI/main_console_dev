import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TerminalView.dart';

class CommandView extends StatefulWidget {
  // ignore: close_sinks
  final StreamController _streamController = StreamController<List>.broadcast();
  @override
  _CommandViewState createState() => _CommandViewState();
}

abstract class COpsProcess {
  static Process proc;
  static int pid;
}

class _CommandViewState extends State<CommandView> {
  BuildContext ctx;
  Widget child;
  List<String> dataList = [];
  TextEditingController tec = TextEditingController();

  Widget placeholder() {
    return CircularProgressIndicator();
  }

  Widget cOpsView() {
    return TerminalView(streamController: widget._streamController);
  }

  void handleStdIn(String data) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data),
          titleTextStyle: TextStyle(),
          content: TextField(
            controller: tec,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your response',
            ),
          ),
          actions: [
            FlatButton(
              color: Colors.grey[900],
              onPressed: () {
                COpsProcess.proc.stdin.writeln(tec.text);
                tec.clear();
                Navigator.pop(context);
              },
              child: Text("Done"),
            ),
          ],
        );
      },
    );
  }

  void handleStdOut(String data) {
    if (data.contains("CAI: COPS: STDIN")) {
      handleStdIn(data.substring(17));
    } else {
      dataList.add(data.trim());
      widget._streamController.add(dataList);
    }
  }

  void runCommandOps() {
    Process.start(
      'python',
      ['..\\command_operations\\main.py'],
      workingDirectory: '.',
    ).then((process) {
      COpsProcess.proc = process;
      COpsProcess.pid = process.pid;
      process.stdout.transform(utf8.decoder).listen((data) => handleStdOut(data));
      setState(() => child = cOpsView());
    });
  }

  @override
  void initState() {
    child = placeholder();
    runCommandOps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: child,
    );
  }
}
