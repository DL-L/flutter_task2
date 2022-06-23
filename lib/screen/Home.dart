import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task2/echo/socket/socket_io.dart';
import 'package:flutter_task2/screen/Subordinate.dart';
import 'package:flutter_task2/screen/addTaskBottomSheet.dart';
import 'package:flutter_task2/screen/admin.dart';
import 'package:flutter_task2/screen/calendar.dart';
import 'package:flutter_task2/screen/invitation_page.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:flutter_task2/service/notification_api.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;
  Echo? echo;
  bool isConnected = false;
  List<String> listeningChannels = [];

  final screens = [
    Calendar(),
    Admin(),
    AddTask(),
    Subordinate(),
    InvitationPage(),
  ];

  @override
  void initState() {
    super.initState();
    initEcho();
  }

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  void initEcho() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print(token);
    echo = initSocketIOClient(token: token);
    (echo?.connector.socket as IO.Socket).onConnect((_) {
      setState(() => isConnected = true);
    });

    (echo?.connector.socket as IO.Socket).onDisconnect((_) {
      setState(() => isConnected = false);
    });
    var connected_user_id = localStorage.getInt('connectedUserId');
    /////
    dynamic taskChannel;
    dynamic invitationChannel;
    taskChannel = echo?.private("task.private.channel.$connected_user_id");
    invitationChannel =
        echo?.private("invitation.private.channel.$connected_user_id");
    Listen(taskChannel, "TaskEvent", 'Task');
    Listen(invitationChannel, "InvitationEvent", 'Invitation');
  }

  Listen(dynamic Channel, String event, String notification_title) {
    Channel.listen(event, (e) {
      if (e == null) return;
      sendNotification(title: notification_title, body: e['message']);
      if (e['message'].toString().contains('new Task')) {
        _updateTask(e['task']['id']);
      }
      print('event: $e');
    });
  }

  void _updateTask(String task_id) async {
    var data = {
      'status_name': 'received',
    };
    print(data);
    var res = await Network().updateTaskSub(data, '/sub/tasks/$task_id');

    print(res);
    setState(() {});
  }

  @override
  void dispose() {
    echo?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = 56;

    final items = <Widget>[
      Icon(
        Icons.calendar_today_outlined,
        size: 30,
        color: Color(0xffe7feff),
      ),
      Icon(
        Icons.supervised_user_circle_outlined,
        size: 30,
        color: Color(0xffe7feff),
      ),
      Icon(
        Icons.add,
        size: 30,
        color: Color(0xffe7feff),
      ),
      Icon(
        Icons.supervised_user_circle_rounded,
        size: 30,
        color: Color(0xffe7feff),
      ),
      Icon(
        Icons.insert_invitation,
        size: 30,
        color: Color(0xffe7feff),
      ),
    ];
    return Scaffold(
      body: screens[index],
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: Colors.black)),
        child: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          key: navigationKey,
          items: items,
          height: 60,
          index: index,
          onTap: (index) => setState(() => this.index = index),
          color: Color(0xff9966cc).withOpacity(0.9),
          buttonBackgroundColor: Color(0xff915c83),
          animationDuration: Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
