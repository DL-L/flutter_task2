import 'package:flutter/material.dart';
import 'package:flutter_task2/models/History.dart';
import 'package:flutter_task2/models/Task.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryTask extends StatefulWidget {
  final Task task;
  const HistoryTask({required this.task, Key? key}) : super(key: key);

  @override
  _HistoryTaskState createState() => _HistoryTaskState();
}

class _HistoryTaskState extends State<HistoryTask> {
  List<History> _histories = [];
  List _statuses = [
    'sent',
    'recieved',
    'seen',
    'confirmed',
    'in progress',
    'unachieved',
    'validated'
  ];

  // _getStatuses() {
  //   var res = Network().getStatuses('/statuses').then((statuses) {
  //     setState(() {
  //       _statuses = statuses;
  //       print(_statuses);
  //     });
  //   });
  // }

  _getHistories() async {
    var data = {
      'id_task': widget.task.id,
    };
    var res =
        await Network().getHistoryData(data, '/histories').then((histories) {
      setState(() {
        _histories = histories;
        print(_histories);
      });
    });
    return _histories;
  }

  @override
  void initState() {
    super.initState();
    _getHistories();
    _histories;
    // _getStatuses();
    _statuses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6082b6),
        title: Text('Task History'),
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _histories.length > 0 ? _histories.length - 1 : 0,
        itemBuilder: (BuildContext context, int index) {
          History history = _histories[index + 1];
          return ExpansionTile(
            title: Text(
                'Edited on ${DateFormat.yMMMEd().format(history.createdAt)}'),
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Column(
                  children: [
                    history.titleTask != _histories[index].titleTask
                        ? _historyTile(
                            index, history.titleTask, null, null, null)
                        : SizedBox.shrink(),
                    history.descriptionTask != _histories[index].descriptionTask
                        ? _historyTile(
                            index, null, history.descriptionTask, null, null)
                        : SizedBox.shrink(),
                    history.deadlineTask != _histories[index].deadlineTask
                        ? _historyTile(
                            index, null, null, history.deadlineTask, null)
                        : SizedBox.shrink(),
                    history.statusIdTask != _histories[index].statusIdTask
                        ? _historyTile(
                            index, null, null, null, history.statusIdTask)
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Row _historyTile(int index, String? title, String? description,
      DateTime? deadline, int? statusId) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        title != null
            ? '${_histories[index].titleTask}'
            : (description != null
                ? '${_histories[index].descriptionTask}'
                : (deadline != null
                    ? _histories[index].deadlineTask == null
                        ? 'null'
                        : DateFormat.yMMMEd()
                            .format(_histories[index].deadlineTask!)
                    : (statusId != null
                        ? '${_statuses[_histories[index].statusIdTask]}'
                        : ''))),
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
              color: Color(0xffb22222),
              fontSize: 15,
              fontWeight: FontWeight.w400),
        ),
      ),
      Icon(
        Icons.arrow_forward_ios,
        size: 12,
      ),
      Text(
        title != null
            ? title
            : (description != null
                ? description
                : (deadline != null
                    ? DateFormat.yMMMEd().format(deadline)
                    : (statusId != null ? _statuses[statusId] : ''))),
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
              color: Color(0xff228b22),
              fontSize: 15,
              fontWeight: FontWeight.w400),
        ),
      ),
    ]);
  }
}
