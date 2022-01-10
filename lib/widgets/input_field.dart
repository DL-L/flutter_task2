import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatelessWidget {
  final String? title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final int? lines;
  final TextInputType? kbtype;
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget,
      this.lines,
      this.kbtype})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(title!,
          //     style: GoogleFonts.lato(
          //         textStyle: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.w400,
          //             color: Colors.black))),
          Container(
            height: 52,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.only(left: 14),
            // decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey, width: 1),
            //     borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  readOnly: widget == null ? false : true,
                  keyboardType: kbtype,
                  maxLines: lines,
                  autofocus: false,
                  cursorColor: Colors.deepPurple,
                  controller: controller,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0),
                    ),
                  ),
                )),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
