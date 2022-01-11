import 'package:flutter/material.dart';
import 'package:flutter_task2/models/Task.dart';
import 'package:flutter_task2/models/Users.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:flutter_task2/widgets/task_tile.dart';

class BuildBottomSheetTasks extends StatefulWidget {
  final User user;
  final bool isItAdmin;
  const BuildBottomSheetTasks(
      {required this.user, required this.isItAdmin, Key? key})
      : super(key: key);

  @override
  _BuildBottomSheetTasksState createState() => _BuildBottomSheetTasksState();
}

class _BuildBottomSheetTasksState extends State<BuildBottomSheetTasks> {
  List<Task> _tasks = [];
  List<Task> _tasks2 = [];

  _getAdminTasks() async {
    var data = {
      'admin_id': widget.user.id,
    };
    var res =
        await Network().getAdminTasksData(data, '/tasks/admin').then((tasks) {
      setState(() {
        _tasks = tasks;
        print(_tasks);
      });
    });
    return _tasks;
  }

  _getSubTasks() async {
    var data = {
      'sub_id': widget.user.id,
    };
    var res =
        await Network().getAdminTasksData(data, '/tasks/sub').then((tasks) {
      setState(() {
        _tasks2 = tasks;
        print(_tasks2);
      });
    });
    return _tasks2;
  }

  @override
  void initState() {
    super.initState();
    _getAdminTasks();
    _tasks;
    _getSubTasks();
    _tasks2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                ],
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: null == (widget.isItAdmin ? _tasks : _tasks2)
                  ? 0
                  : (widget.isItAdmin ? _tasks.length : _tasks2.length),
              itemBuilder: (BuildContext context, int index) {
                Task task = widget.isItAdmin ? _tasks[index] : _tasks2[index];
                return TaskTile(task, widget.isItAdmin);
                // ListTile(
                //   contentPadding:
                //       EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                //   leading: Container(
                //     padding: EdgeInsets.only(right: 12.0),
                //     decoration: new BoxDecoration(
                //         border: new Border(
                //             right: new BorderSide(
                //                 width: 1.0, color: Colors.black45))),
                //     child: Text,
                //   ),
                //   title: Text(
                //     task.title,
                //     style: TextStyle(
                //         color: Colors.black, fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: Text(
                //     task.title,
                //     style: TextStyle(
                //         color: Colors.white, fontWeight: FontWeight.bold),
                //   ),
                //   trailing: Icon(Icons.keyboard_arrow_right,
                //       color: Colors.white, size: 30.0),
                //   onTap: () {
                //     // Navigator.push(context,
                //     //     MaterialPageRoute(builder: (context) => DetailPage()));
                //   },
                // );
              },
            )
          ],
        ),
      ),
    );
  }
}
