import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task2/models/Task.dart';
import 'package:flutter_task2/models/User.dart';
import 'package:flutter_task2/models/Users.dart';
import 'package:flutter_task2/screen/edit_task_admin.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:flutter_task2/widgets/Cupertino_input_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BuildBottomSheet extends StatefulWidget {
  final Task task;
  final bool isItTodo;

  const BuildBottomSheet({required this.task, required this.isItTodo, Key? key})
      : super(key: key);

  @override
  _BuildBottomSheetState createState() => _BuildBottomSheetState();
}

class _BuildBottomSheetState extends State<BuildBottomSheet> {
  User1? _user1;
  User1? _user2;
  late Future data1;
  late Future data2;

  _getUserSub() async {
    var res = await Network()
        .getUserData('/user/${widget.task.relation.subId}')
        .then((user) {
      setState(() {
        _user1 = user;
      });
    });
    return _user1;
  }

  _getUserAdmin() async {
    var res = await Network()
        .getUserData('/user/${widget.task.relation.adminId}')
        .then((user) {
      setState(() {
        _user2 = user;
      });
    });
    return _user2;
  }

  @override
  void initState() {
    super.initState();
    data1 = _getUserSub();
    data2 = _getUserAdmin();
    _user1;
    _user2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.pen),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                EditTaskAdmin(task: widget.task)));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.isItTodo
                    ? FutureBuilder(
                        future: data2,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return UserBar('From : ', _user2!.email);
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )
                    : FutureBuilder(
                        future: data1,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return UserBar('To : ', _user1!.email);
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                ClipOval(
                  child: Image.network(
                    'https://vectorified.com/images/facebook-no-profile-picture-icon-26.jpg',
                    fit: BoxFit.cover,
                    width: 90.0,
                    height: 90.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            // padding: const EdgeInsets.only(top: 7),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoField(
                  controller: null,
                  expands: false,
                  inputtype: null,
                  maxlines: 1,
                  minlines: 1,
                  placeHolder: widget.task.title,
                  prefix: Container(
                    height: 17,
                    width: 17,
                    decoration: BoxDecoration(
                        color: widget.isItTodo
                            ? Color(0xff9966cc)
                            : Color(0xffcc9966),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  holderStyle: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                  inputAction: null,
                  suffix: null,
                  readOnly: true,
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
                  controller: null,
                  expands: true,
                  inputtype: null,
                  maxlines: null,
                  minlines: null,
                  placeHolder: widget.task.description,
                  prefix: Container(child: Icon(CupertinoIcons.text_alignleft)),
                  holderStyle: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700])),
                  inputAction: null,
                  suffix: null,
                  readOnly: true,
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
                  controller: null,
                  expands: false,
                  inputtype: null,
                  maxlines: 1,
                  minlines: 1,
                  placeHolder: widget.task.status.name,
                  prefix: Container(
                    height: 17,
                    width: 17,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  holderStyle: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue)),
                  inputAction: null,
                  suffix: null,
                  readOnly: true,
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
                    Container(
                      // color: Colors.amber,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 8.0, left: 50),
                      child: Text(
                        DateFormat.E().format(
                                widget.task.deadline ?? DateTime.now()) +
                            ', ' +
                            DateFormat.LLL().format(
                                widget.task.deadline ?? DateTime.now()) +
                            ' ' +
                            DateFormat.d().format(
                                widget.task.deadline ?? DateTime.now()) +
                            ', ' +
                            DateFormat.y()
                                .format(widget.task.deadline ?? DateTime.now()),
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                      ),
                    )
                  ],
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Row UserBar(String text, String user) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
        ),
        Text(
          user,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.w300)),
        ),
      ],
    );
  }
}
