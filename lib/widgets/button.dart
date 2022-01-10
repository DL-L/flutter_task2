import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  final String label;
  final Function() onTap;
  final Color color;
  const Button(
      {Key? key, required this.label, required this.onTap, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: color),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[50])),
          ),
        ),
      ),
    );
  }
}
