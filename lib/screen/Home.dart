import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task2/screen/Subordinate.dart';
import 'package:flutter_task2/screen/addTaskBottomSheet.dart';
import 'package:flutter_task2/screen/admin.dart';
import 'package:flutter_task2/screen/calendar.dart';
import 'package:flutter_task2/screen/invitation_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  final screens = [
    Calendar(),
    Admin(),
    AddTask(),
    Subordinate(),
    InvitationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = 56;

    final items = <Widget>[
      // Icon(
      //   Icons.person,
      //   size: 30,
      // ),
      // Icon(
      //   Icons.person_outline_outlined,
      //   size: 30,
      // ),
      // Icon(
      //   Icons.add,
      //   size: 30,
      // ),
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
