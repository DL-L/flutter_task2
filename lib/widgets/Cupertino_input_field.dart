import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CupertinoField extends StatelessWidget {
  const CupertinoField({
    Key? key,
    required this.controller,
    required this.prefix,
    required this.expands,
    required this.maxlines,
    required this.minlines,
    required this.inputtype,
    this.placeHolder,
    required this.holderStyle,
    required this.inputAction,
    required this.suffix,
    required this.readOnly,
  }) : super(key: key);

  final TextEditingController? controller;
  final Widget? prefix;
  final bool expands;
  final int? maxlines;
  final int? minlines;
  final TextInputType? inputtype;
  final String? placeHolder;
  final TextStyle holderStyle;
  final TextInputAction? inputAction;
  final Widget? suffix;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: CupertinoTextField(
            readOnly: readOnly,
            style: holderStyle,
            prefix: prefix,
            expands: expands,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            controller: controller,
            maxLines: maxlines,
            minLines: minlines,
            // clearButtonMode: OverlayVisibilityMode.editing,
            keyboardType: inputtype,
            // maxLines: 5,
            placeholder: placeHolder,
            placeholderStyle: holderStyle,
            textInputAction: inputAction,
            suffix: suffix,
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
