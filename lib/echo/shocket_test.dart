import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_task2/echo/app_state.dart';
import 'package:flutter_task2/echo/socket_widget.dart/actions_view.dart';
import 'package:flutter_task2/echo/socket_widget.dart/logs_view.dart';

class HomeSocket extends StatefulWidget {
  @override
  _HomeSocketState createState() => _HomeSocketState();
}

class _HomeSocketState extends State<HomeSocket> {
  String broadcaster = 'socket.io';
  List<LogString> logs = [];

  log(String event) {
    var now = new DateTime.now();
    String date = "${now.hour.toString().padLeft(2, '0')}";
    date += ":${now.minute.toString().padLeft(2, '0')}";
    date += ":${now.second.toString().padLeft(2, '0')}";

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        logs.insert(0, LogString(date: date, text: event));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setState(() => logs.clear());
            },
            tooltip: 'Clear log',
            icon: Icon(
              Icons.block,
              color: Colors.grey,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
          ),
        ),
      ),
      body: AppState(
        logs: logs,
        log: log,
        child: Scaffold(
          body: Column(
            children: [
              Flexible(
                child: LogsView(),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: ActionsView(broadcaster: broadcaster),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
