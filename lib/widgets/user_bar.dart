import 'package:flutter/material.dart';

class GradientAppBarFb1 extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final bool itItAdmin;

  GradientAppBarFb1({required this.itItAdmin, Key? key})
      : preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  @override
  State<GradientAppBarFb1> createState() => _GradientAppBarFb1State();
}

class _GradientAppBarFb1State extends State<GradientAppBarFb1> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff9966cc);
    const secondaryColor = Color(0xff6D28D9);
    const accentColor = Color(0xffffffff);
    const backgroundColor = Color(0xffffffff);
    const errorColor = Color(0xffEF4444);

    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(widget.itItAdmin ? "Supervisors" : 'Subordinates',
          style: TextStyle(color: Colors.white)),
      backgroundColor: primaryColor,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            stops: [0.5, 1.0],
          ),
        ),
      ),
    );
  }
}
