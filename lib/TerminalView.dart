import 'dart:async';

import 'package:flutter/material.dart';

class TerminalView extends StatefulWidget {
  TerminalView({@required this.streamController, this.placeholderText});

  final StreamController<List> streamController;
  final ScrollController _scrollController = ScrollController();
  final String placeholderText;

  void _scrollToBottom() => _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

  @override
  _TerminalViewState createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: StreamBuilder(
        stream: widget.streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Text(widget.placeholderText ?? "Waiting for response...");
          }
          // Scroll to Bottom
          WidgetsBinding.instance.addPostFrameCallback((_) => widget._scrollToBottom());
          return ListView.builder(
            controller: widget._scrollController,
            itemCount: snapshot.data.length,
            itemBuilder: (c, i) {
              return Text(snapshot.data[i].trim());
            },
          );
        },
      ),
    );
  }
}
