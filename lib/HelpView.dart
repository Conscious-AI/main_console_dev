import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'CommandSection.dart';

class TableCellText extends StatelessWidget {
  const TableCellText({
    Key key,
    @required this.textWidget,
    this.insets = const EdgeInsets.all(5.0),
  }) : super(key: key);

  final Text textWidget;
  final EdgeInsets insets;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: insets,
        child: Center(child: textWidget),
      ),
    );
  }
}

class HelpView extends StatefulWidget {
  @override
  _HelpViewState createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {
  ScrollController scrollCon = ScrollController();

  TableRow tableRowCellText({
    String name,
    String description,
    EdgeInsets insets = const EdgeInsets.all(5.0),
    double textScaling = 1.0,
    TextStyle textStyle,
  }) {
    return TableRow(
      children: [
        TableCellText(
          insets: insets,
          textWidget: Text(
            name,
            textScaleFactor: textScaling,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
        TableCellText(
          insets: insets,
          textWidget: Text(
            description,
            textScaleFactor: textScaling,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 40.0,
        title: Text(
          "Commands Help Table",
          textScaleFactor: 0.85,
        ),
        leading: IconButton(
          splashRadius: 15.0,
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => context.read(childProvider).state = cOpsView,
        ),
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        thickness: 4.0,
        controller: scrollCon,
        child: SingleChildScrollView(
          controller: scrollCon,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(10.0),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(
              width: 2.0,
              color: Colors.white30,
            ),
            children: [
              tableRowCellText(
                name: "Commands",
                description: "What they do",
                insets: EdgeInsets.all(10.0),
                textScaling: 1.25,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              tableRowCellText(
                name: "hello",
                description: "A very basic interaction command.",
              ),
              tableRowCellText(
                name: "am i online or offline ?",
                description: "This command checks whether current system has an active internet connectiom or not.",
              ),
              tableRowCellText(
                name: "what's on my clipboard ?",
                description: "Speaks the current text contents of the clipboard (if it has any).",
              ),
              tableRowCellText(
                name: "clear the clipboard",
                description: "Deletes anything that's currently on the clipboard.",
              ),
              tableRowCellText(
                name: "set a reminder",
                description: "Sets an offline reminder for any task.",
              ),
              tableRowCellText(
                name: "what's my IP address",
                description: "Speaks private and public IP addresses of the current system",
              ),
              tableRowCellText(
                name: "search wikipedia",
                description: "Searches and speaks a very summarized form of a query on wikipedia.",
              ),
              tableRowCellText(
                name: "what's the current weather",
                description: "Fetches current system's local weather data and speaks in a summarized way.",
              ),
              tableRowCellText(
                name: "what's the weather forecast",
                description: "Fetches current system's local weather forecast data for tommorrow and speaks.",
              ),
              tableRowCellText(
                name: "show help info",
                description: "Shows this command information table screen.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
