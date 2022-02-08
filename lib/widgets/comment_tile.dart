import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentTile extends StatefulWidget {
  final String text;
  final bool? seen;
  const CommentTile({required this.text, required this.seen, Key? key})
      : super(key: key);

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  @override
  Widget build(BuildContext context) {
    return
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 13),
        //   child: Card(
        //     color: Color(0xff986960).withOpacity(0.7),
        //     child: ListTile(
        //       title: Text(
        //         widget.text,
        //         style: GoogleFonts.lato(
        //           textStyle: TextStyle(
        //               fontSize: 18,
        //               fontWeight: FontWeight.bold,
        //               color: Colors.black.withOpacity(0.7)),
        //         ),
        //       ),
        //       trailing: Icon(
        //         Icons.circle,
        //         size: 15,
        //         color: widget.seen ? Color(0xff7fff00) : Colors.grey[400],
        //       ),
        //     ),
        //   ),
        // );
        Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      height: 70,
      child: Container(
        padding: EdgeInsets.all(10),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xff986960).withOpacity(0.7),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.text,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7)),
                ),
              ),
            ),
            RotatedBox(
                quarterTurns: 3,
                child: Icon(
                  Icons.circle,
                  size: 15,
                  color: widget.seen! ? Color(0xff7fff00) : Colors.grey[400],
                )
                // Text(
                //   widget.seen ? 'Seen' : 'Sent',
                //   style: GoogleFonts.lato(
                //     textStyle: TextStyle(
                //         fontSize: 12,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black),
                //   ),
                // ),
                ),
          ],
        ),
      ),
    );
  }
}
