import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_task2/screen/Home.dart';
import 'package:flutter_task2/screen/calendar.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String text = '';
  bool _isLoading = false;

  void _onKeyboardTap(String value) {
    setState(() {
      if (text.length < 6) {
        text = text + value;
      }
    });
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            text[position],
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade600, width: 0),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: Color(0xff4338CA),
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Color(0xff4338CA),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                                'Enter 6 digits verification code sent to your number',
                                style: GoogleFonts.montserrat(
                                    color: Color(0xff4338CA),
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500))),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              otpNumberWidget(0),
                              otpNumberWidget(1),
                              otpNumberWidget(2),
                              otpNumberWidget(3),
                              otpNumberWidget(4),
                              otpNumberWidget(5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: RaisedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      color: Color(0xff4338CA),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              !_isLoading ? 'Confirm' : 'Loading',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xff4338CA),
                                size: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  NumericKeyboard(
                    onKeyboardTap: _onKeyboardTap,
                    textColor: Color(0xff4338CA),
                    rightIcon: Icon(
                      Icons.backspace,
                      color: Colors.grey,
                    ),
                    rightButtonFn: () {
                      setState(() {
                        text = text.substring(0, text.length - 1);
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'code': text,
    };

    var res = await Network().postData(data, '/user/auth');

    try {
      if (res.data['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        var user = res.data['user'];
        var userDecode = json.encode(user);
        localStorage.setString('user', userDecode);
        localStorage.setString('token', res.data['access_token']);
        var token = localStorage.getString('token');
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => Home()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The code is incorrect'),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
}
