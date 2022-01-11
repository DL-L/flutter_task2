import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task2/screen/otp.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final _countryCode = ['+212'];
  String? value = '+212';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // key: loginStore.loginScaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: 240,
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                margin: const EdgeInsets.only(top: 100),
                                decoration: const BoxDecoration(
                                    color: Color(0xFFE1E0F5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                              ),
                            ),
                            Center(
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Image.network(
                                    "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/illustrations%2Fundraw_Accept_terms_re_lj38%201.png?alt=media&token=476b97fd-ba66-4f62-94a7-bce4be794f36",
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Sign Up',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600))))
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'We will send you an ',
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: 'One Time Password ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'on this mobile number',
                                  style: TextStyle(color: Colors.black)),
                            ]),
                          )),
                      Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              // height: 40,
                              constraints: const BoxConstraints(maxWidth: 330),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: CupertinoTextFormFieldRow(
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r'^(?:[6,7]9)?$')
                                          .hasMatch(value)) {
                                  } else {
                                    return null;
                                  }
                                },
                                prefix: DropdownButton<String>(
                                  underline: Container(
                                    height: 0,
                                  ),
                                  elevation: 0,
                                  value: value,
                                  items:
                                      _countryCode.map(buildMenuItem).toList(),
                                  onChanged: (value) => setState(() {
                                    this.value = value;
                                  }),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4))),
                                controller: phoneController,
                                // clearButtonMode: OverlayVisibilityMode.editing,
                                keyboardType: TextInputType.phone,
                                maxLines: 1,
                                placeholder: '...',
                              ),
                            ),
                            Container(
                              height: 70,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: RaisedButton(
                                onPressed: () {
                                  _isLoading ? null : _handleLogin();
                                },
                                color: Colors.deepPurple.withOpacity(0.9),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        _isLoading ? 'Loading' : 'Next',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.black,
                                          size: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String value) => DropdownMenuItem(
        value: value,
        child: Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black)),
      );

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'phone_num': phoneController.text,
    };
    print(phoneController.text);
    print('object');
    var res = await Network().postData(data, '/user/validate');
    print(res);
    try {
      if (res.data['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        var user = res.data['user'];
        var userDecode = json.encode(user);
        // print(userDecode);
        localStorage.setString('user', userDecode);
        localStorage.setString('code', res.data['code_session'].toString());

        var userJson = localStorage.getString('user');
        var user2 = json.decode(userJson!);
        // print(user2['id']);
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => Otp()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The phone number is invalid'),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
}
