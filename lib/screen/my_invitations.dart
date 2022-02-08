import 'package:flutter/material.dart';
import 'package:flutter_task2/models/Invitation.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:flutter_task2/widgets/comment_tile.dart';

class MyInvitations extends StatefulWidget {
  const MyInvitations({Key? key}) : super(key: key);

  @override
  _MyInvitationsState createState() => _MyInvitationsState();
}

class _MyInvitationsState extends State<MyInvitations> {
  List<Invitation> _invitations = [];

  _getInvitations() async {
    var res =
        await Network().getInvitationData('/myinvitations').then((invitations) {
      setState(() {
        _invitations = invitations;
      });
    });
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
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: ListView.builder(
                itemCount: _invitations.length,
                itemBuilder: (BuildContext context, index) {
                  Invitation invitation = _invitations[index];
                  return CommentTile(
                      text: 'To : ${invitation.receiver.email}', seen: false);
                }),
          )
        : Center(
            child: Text('You did not send any invitation'),
          );
  }
}
