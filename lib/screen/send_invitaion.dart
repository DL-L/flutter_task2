import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task2/models/Invitation.dart';
import 'package:flutter_task2/models/Users.dart';
import 'package:flutter_task2/screen/invitation_page.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:flutter_task2/widgets/invitation_dialogue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SendInvitation extends StatefulWidget {
  const SendInvitation({Key? key}) : super(key: key);

  @override
  _SendInvitationState createState() => _SendInvitationState();
}

class _SendInvitationState extends State<SendInvitation> {
  List<Contact> contacts = [];
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
    }
  }

  getAllContacts() async {
    List<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    setState(() {
      contacts = _contacts;
    });
    var res = Network().getPublicData('/users').then((users) {
      setState(() {
        _users = users;
      });

      contacts.retainWhere((element) {
        bool test = _users.any((e) => e.phoneNumber.contains(element.phones!
            .elementAt(0)
            .value!
            .replaceAll('-', '')
            .substring(5)));
        if (test == true) {
          return true;
        } else {
          return false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: contacts.length,
          itemBuilder: (BuildContext context, index) {
            Contact contact = contacts[index];
            return GestureDetector(
              onTap: () async {
                final result = await showDialog(
                    context: context, builder: (_) => InvitationDialogue());
                _users.retainWhere((element) =>
                    element.phoneNumber ==
                    contact.phones!
                        .elementAt(0)
                        .value!
                        .replaceAll('-', '')
                        .substring(5));
                if (result) {
                  _addInvitation();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('The invitation has been created successfully'),
                    ),
                  );
                }
              },
              child: ListTile(
                leading: CircleAvatar(
                    child: Text(contact.initials(),
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.blue),
                title: Text(contact.displayName!),
                subtitle: Text(contact.phones!.elementAt(0).value!),
              ),
            );
          },
        ),
      ),
    );
  }

  void _addInvitation() async {
    var data = {
      'to': _users.first.id,
    };
    var res = await Network().postData(data, '/invitation');
    print(res);
  }
}
