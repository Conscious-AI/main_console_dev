import 'dart:async';

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'TerminalView.dart';

class LogView extends StatefulWidget {
  // ignore: close_sinks
  final StreamController _streamController = StreamController<List>.broadcast();
  final IO.Socket _socket = IO.io('http://localhost:6969', <String, dynamic>{
    'transports': ['websocket']
  });

  @override
  _LogViewState createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  Widget child;

  Widget placeholder() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text("Attempting to connect to local server..."),
        ],
      ),
    );
  }

  Widget loggingView() {
    return TerminalView(
      streamController: widget._streamController,
      placeholderText: "Waiting for response from server...",
    );
  }

  void _getdata() {
    widget._socket.on('connect', (_) {
      print('Connected to local server.');
      setState(() => child = loggingView());
    });

    widget._socket.on('disconnect', (_) {
      print('Disconnected from local server.');
      setState(() => child = placeholder());
    });

    widget._socket.on('message', (data) {
      widget._streamController.add(data);
    });
  }

  @override
  void initState() {
    child = placeholder();
    _getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: child,
    );
  }
}
