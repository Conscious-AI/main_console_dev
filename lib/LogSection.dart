import 'dart:async';

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class LogView extends StatefulWidget {
  // ignore: close_sinks
  final StreamController _streamController = StreamController<List>();
  final ScrollController _scrollController = ScrollController();
  final IO.Socket _socket = IO.io('http://localhost:6969', <String, dynamic>{
    'transports': ['websocket']
  });

  @override
  _LogViewState createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  void _scrollToBottom() => widget._scrollController.jumpTo(widget._scrollController.position.maxScrollExtent);

  void _getdata() {
    widget._socket.on('connect', (_) {
      print('Connected to logging server.');
    });

    widget._socket.on('disconnect', (_) {
      print('Disconnected from logging server.');
    });

    widget._socket.on('message', (data) {
      widget._streamController.add(data);
    });
  }

  @override
  void initState() {
    _getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget._streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        }
        // Scroll to Bottom
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        return ListView.builder(
          controller: widget._scrollController,
          itemCount: snapshot.data.length,
          itemBuilder: (c, i) {
            return Text(snapshot.data[i].trim());
          },
        );
      },
    );
  }
}
