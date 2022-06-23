import 'package:flutter/material.dart';
import 'package:flutter_task2/models/Invitation.dart';
import 'package:flutter_task2/service/api.dart';

class NewInvitations extends StatefulWidget {
  const NewInvitations({Key? key}) : super(key: key);

  @override
  _NewInvitationsState createState() => _NewInvitationsState();
}

class _NewInvitationsState extends State<NewInvitations> {
  List<Invitation> _invitations = [];

  _getInvitations() async {
    var res = await Network()
        .getInvitationData('/newinvitations')
        .then((invitations) {
      setState(() {
        _invitations = invitations;
      });
    });
    print(_invitations);
    return _invitations;
  }

  @override
  void initState() {
    super.initState();
    _getInvitations();
  }

  @override
  Widget build(BuildContext context) {
    return _invitations.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: ListView.separated(
              itemCount: _invitations.length,
              itemBuilder: (BuildContext context, index) {
                Invitation invitation = _invitations[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: MediaQuery.of(context).size.height / 8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(12, 26),
                            blurRadius: 50,
                            spreadRadius: 0,
                            color: Colors.grey),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('From : ${invitation.transmitter.email}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 3.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SimpleBtn1(
                              text: "Accept",
                              onPressed: () {
                                _updateInvitationAccepted(invitation);
                                setState(() {
                                  _getInvitations();
                                });
                              }),
                          SimpleBtn1(
                            text: "Reject",
                            onPressed: () {
                              _deleteInvitation(invitation.id.toString());
                            },
                            invertedColors: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
          )
        : Center(
            child: Text('You did not receive any invitation'),
          );
  }

  void _updateInvitationAccepted(Invitation invitation) async {
    var data = {
      'admin_id': invitation.transmitter.id,
    };

    var res = await Network()
        .updateInvitation(data, '/newinvitations/${invitation.id}');
    print(res);
  }

  void _deleteInvitation(String invitationId) async {
    var res = await Network().DeleteInvitation(invitationId);
    setState(() {
      _getInvitations();
    });
    print(res);
  }
}

class SimpleBtn1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool invertedColors;
  const SimpleBtn1(
      {required this.text,
      required this.onPressed,
      this.invertedColors = false,
      Key? key})
      : super(key: key);
  final primaryColor = const Color(0xff655D8A);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            alignment: Alignment.center,
            side: MaterialStateProperty.all(
                BorderSide(width: 1, color: primaryColor)),
            padding: MaterialStateProperty.all(
                const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
            backgroundColor: MaterialStateProperty.all(
                invertedColors ? accentColor : primaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            )),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: invertedColors ? primaryColor : accentColor, fontSize: 16),
        ));
  }
}
