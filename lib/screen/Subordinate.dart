import 'package:flutter/material.dart';
import 'package:flutter_task2/models/Users.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:flutter_task2/widgets/userCard.dart';

class Subordinate extends StatefulWidget {
  const Subordinate({Key? key}) : super(key: key);

  @override
  _SubordinateState createState() => _SubordinateState();
}

class _SubordinateState extends State<Subordinate> {
  List<User> _users = [];

  _getSubs() {
    var res = Network().getPublicData('/users/subs').then((users) {
      setState(() {
        _users = users;
        print(_users);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getSubs();
    _users;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              onPressed: () => null,
            );
          }),
    );
  }
}
