import 'package:flutter/material.dart';
import 'package:flutter_task2/screen/my_invitations.dart';
import 'package:flutter_task2/screen/new_invitations.dart';
import 'package:flutter_task2/screen/send_invitaion.dart';
import 'package:get/get.dart';

class InvitationPage extends StatefulWidget {
  @override
  _InvitationPageState createState() => _InvitationPageState();
}

class _InvitationPageState extends State<InvitationPage>
// with SingleTickerProviderStateMixin
{
  // late TabController _tabController;

  @override
  void initState() {
    // _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _tabController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff967bb6),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'My invitations',
                // icon: Icon(Icons.insert_invitation_outlined),
              ),
              Tab(
                text: 'New Invitations',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyInvitations(),
            Center(
              child: NewInvitations(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          backgroundColor: Color(0xff967bb6),
          onPressed: () {
            Get.to(() => SendInvitation());
          },
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
