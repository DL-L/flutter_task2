import 'package:flutter/material.dart';
import 'package:flutter_task2/models/Users.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:flutter_task2/widgets/build_bottom_sheet_tasks.dart';
import 'package:flutter_task2/widgets/userCard.dart';
import 'package:flutter_task2/widgets/user_bar.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List<User> _users = [];
  bool isItAdmin = true;

  _getAdmin() {
    var res = Network().getPublicData('/users/admins').then((users) {
      setState(() {
        _users = users;
        print(_users);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getAdmin();
    _users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBarFb1(
        itItAdmin: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext context, int index) {
              User user = _users[index];
              return CardFb2(
                text: user.email,
                imageUrl:
                    'https://static.vecteezy.com/system/resources/previews/000/649/115/original/user-icon-symbol-sign-vector.jpg',
                subtitle: '+212 ' + user.phoneNumber,
                onPressed: () {
                  bottomSheet(context, user, index);
                },
              );
            }),
      ),
    );
  }

  Future bottomSheet(BuildContext context, User user, int index) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(80))),
        context: context,
        builder: (context) => BuildBottomSheetTasks(
              user: user,
              isItAdmin: true,
            ));
  }
}
