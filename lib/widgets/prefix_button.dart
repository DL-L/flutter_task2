import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrefixButton extends StatelessWidget {
  final Icon icon;
  final String text;
  const PrefixButton({
    required this.icon,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            child: icon,
          ),
          flex: 1,
        ),
        Expanded(
          flex: 8,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              text,
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }
}
