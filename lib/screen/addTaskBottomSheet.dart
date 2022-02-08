import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_task2/echo/socket/socket_io.dart';
import 'package:flutter_task2/models/Users.dart';
import 'package:flutter_task2/screen/Home.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:flutter_task2/widgets/Cupertino_input_field.dart';
import 'package:flutter_task2/widgets/button.dart';
import 'package:flutter_task2/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  DateTime _date = DateTime.now();
  String? value;
  List<User> _users = [];
  final _username = ['<<Select a User>>'];
  int index = 0;
  String _selectedUser = 'None';

  _getSubs() {
    var res = Network().getPublicData('/users/subs').then((users) {
      setState(() {
        _users = users;
        for (var i = 0; i < _users.length; i++) {
          _username.add(_users[i].phoneNumber);
        }
        print(_users);
      });
    });
    return _users;
  }

  _getUsersNames() {
    setState(() {
      for (var i = 0; i < _users.length; i++) {
        print(_users[i]);
        _username.add(_users[i].phoneNumber);
      }
    });
    print(_username);
    return _username;
  }

  @override
  void initState() {
    super.initState();
    _getSubs();
    _users;
    _username;
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropEnabled: true,
      parallaxEnabled: true,
      slideDirection: SlideDirection.UP,
      defaultPanelState: PanelState.OPEN,
      maxHeight: MediaQuery.of(context).size.height,
      header: _header(),
      panel: Container(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoField(
              controller: titleController,
              expands: false,
              inputtype: TextInputType.text,
              maxlines: 1,
              minlines: 1,
              placeHolder: 'Add title',
              prefix: SizedBox(
                width: 25,
              ),
              holderStyle: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700])),
              inputAction: TextInputAction.next,
              suffix: null,
              readOnly: false,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CupertinoField(
              controller: descriptionController,
              expands: true,
              inputtype: TextInputType.multiline,
              maxlines: null,
              minlines: null,
              placeHolder: 'Add description',
              prefix: Container(child: Icon(CupertinoIcons.text_alignleft)),
              holderStyle: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700])),
              inputAction: TextInputAction.newline,
              suffix: null,
              readOnly: false,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Container(
                    // color: Colors.amber,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 8.0, left: 50),
                    child: Text(
                      DateFormat.E().format(_date) +
                          ', ' +
                          DateFormat.LLL().format(_date) +
                          ' ' +
                          DateFormat.d().format(_date) +
                          ', ' +
                          DateFormat.y().format(_date),
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ),
                  ),
                  onTap: () {
                    _getDateFromUser();
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35),
              child: InputField(
                  title: null,
                  hint: _selectedUser == 'None' ? 'Select a User' : '',
                  controller: phoneController,
                  widget: DropdownButton<String>(
                    value: value,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blueGrey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (value) => setState(() {
                      this.value = value;
                      _selectedUser = value!;
                    }),
                    items: _username.map(buildMenuItem).toList(),
                  )),
            ),
            // SizedBox(
            //   height: 400,
            //   child: CupertinoPicker(
            //     // looping: true,
            //     itemExtent: 64,
            //     onSelectedItemChanged: (index) {
            //       setState(() {
            //         index = index;
            //       });
            //     },
            //     children: _users.map((e) => buildItem(context, e)).toList(),
            //   ),
            // ),
          ],
        )),
      ),
      body: Center(
        child: Text("This is the Widget behind the sliding panel"),
      ),
    );
  }

  // Container buildItem(BuildContext context, User user) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: 75,
  //     padding: const EdgeInsets.all(15.0),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12.5),
  //       boxShadow: [
  //         BoxShadow(
  //             offset: const Offset(10, 20),
  //             blurRadius: 10,
  //             spreadRadius: 0,
  //             color: Colors.grey.withOpacity(.05)),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         ClipOval(
  //             child: Image.network(
  //                 'https://static.vecteezy.com/system/resources/previews/000/649/115/original/user-icon-symbol-sign-vector.jpg',
  //                 height: 59,
  //                 fit: BoxFit.cover)),
  //         const SizedBox(
  //           width: 15,
  //         ),
  //         Text(user.email,
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               color: Colors.black,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 18,
  //             )),
  //         const Spacer(),
  //         Text(
  //           user.phoneNumber,
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(
  //               color: Colors.grey,
  //               fontWeight: FontWeight.normal,
  //               fontSize: 12),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16, left: 150),
          width: 70,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Container(
                    margin: EdgeInsets.only(right: 210),
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.close)),
                onTap: () => Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => Home())),
              ),
              Button(
                  label: 'Create Task',
                  color: Color(0xff915c83),
                  onTap: () {
                    _addTask();
                    // Get.to(Home());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('The task has been created successfully'),
                      ),
                    );
                  })
            ],
          ),
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showRoundedDatePicker(
        height: 305,
        context: context,
        borderRadius: 16,
        theme: ThemeData.dark(),
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1));

    if (_pickerDate != null) {
      setState(() {
        _date = _pickerDate;
      });
    } else {
      print('its null');
    }
  }

  DropdownMenuItem<String> buildMenuItem(String user) => DropdownMenuItem(
        value: user,
        child: Text(
          user,
          style: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
        ),
      );

  void _addTask() async {
    initSocketIOClient().private('task.created').listen('ActionEvent', (e) {
      print(e);
    });
    var data = {
      'sub_user': _selectedUser,
      'title': titleController.text,
      'description': descriptionController.text,
      'deadline': _date.toString()
    };
    print(data);
    // print(jsonEncode(data));
    var res = await Network().postData(data, '/tasks');
    print('dalal');
    print(res);
    initSocketIOClient().private('task.created').listen('ActionEvent', (e) {
      print(e);
    });
  }
}
