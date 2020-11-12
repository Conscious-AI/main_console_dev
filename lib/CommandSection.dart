import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'TerminalView.dart';
import 'HelpView.dart';

final childProvider = StateProvider<Widget>((ref) => CircularProgressIndicator());
final _streamController = StreamController<List>.broadcast();
final cOpsView = TerminalView(streamController: _streamController);
final helpView = HelpView();

class CommandView extends StatefulWidget {
  @override
  _CommandViewState createState() => _CommandViewState();
}

abstract class COpsProcess {
  static Process proc;
  static int pid;
}

class _CommandViewState extends State<CommandView> {
  BuildContext ctx;
  List<String> dataList = [];
  TextEditingController tec = TextEditingController();

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
            autofocus: true,
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

  void handleStdInTime(String data) {
    Future<TimeOfDay> selectedTime = showTimePicker(
      context: ctx,
      initialTime: TimeOfDay.now(),
      helpText: data,
    );

    selectedTime.then((value) {
      if (value != null) {
        String time = "${value.hour}:${value.minute}";
        COpsProcess.proc.stdin.writeln(time);
      } else {
        COpsProcess.proc.stdin.writeln();
      }
    });
  }

  void handleStdInHelp() {
    COpsProcess.proc.stdin.writeln();
    ctx.read(childProvider).state = helpView;
  }

  void handleStdOut(String data) {
    if (data.contains("CAI: COPS: STDIN")) {
      if (data.contains("CAI: COPS: STDIN: TIME")) {
        handleStdInTime(data.substring(24));
        return;
      }
      if (data.contains("CAI: COPS: STDIN: DISPLAY_HELP_INFO")) {
        handleStdInHelp();
        return;
      }
      handleStdIn(data.substring(18));
      return;
    }
    dataList.add(data.trim());
    _streamController.add(dataList);
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
      process.stderr.transform(utf8.decoder).listen((data) => print(data));
      ctx.read(childProvider).state = cOpsView;
    });
  }

  @override
  void initState() {
    runCommandOps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Consumer(
      builder: (context, watch, _) {
        Widget child = watch(childProvider).state;
        return AnimatedSwitcher(
          duration: Duration(seconds: 1),
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          child: child,
        );
      },
    );
  }
}
