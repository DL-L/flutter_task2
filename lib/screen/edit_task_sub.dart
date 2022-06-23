import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task2/models/Task.dart';
import 'package:flutter_task2/models/notifiers.dart';
import 'package:flutter_task2/screen/Home.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:flutter_task2/widgets/Cupertino_input_field.dart';
import 'package:flutter_task2/widgets/button.dart';
import 'package:flutter_task2/widgets/comment_tile.dart';
import 'package:flutter_task2/widgets/prefix_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EditTaskSub extends StatefulWidget {
  final Task task;
  const EditTaskSub({required this.task, Key? key}) : super(key: key);

  @override
  _EditTaskSubState createState() => _EditTaskSubState();
}

class _EditTaskSubState extends State<EditTaskSub> {
  List<Status> _statuses = [];
  String _statusValue = '';
  bool _unachieved = false;
  TextEditingController commentController = TextEditingController();
  bool _editMode = false;

  _getStatuses() {
    var res = Network().getStatuses('/statuses').then((statuses) {
      setState(() {
        _statuses = statuses;
        print(_statuses);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getStatuses();
    _statuses;
    _statusValue = widget.task.status.name;
    if (widget.task.status.name == 'unachieved') {
      _unachieved = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
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
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    widget.task.title.toUpperCase(),
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[800])),
                  ),
                ),
                Divider(
                  color: Colors.grey[600],
                ),
                GestureDetector(
                    child: PrefixButton(
                      icon: Icon(Icons.task_alt),
                      text: _statusValue,
                    ),
                    onTap: () {
                      _showSingleChoiceDialog(context);
                    }),
                Divider(),
                _unachieved == true
                    ? CupertinoField(
                        controller: commentController,
                        expands: true,
                        inputtype: TextInputType.multiline,
                        maxlines: null,
                        minlines: null,
                        placeHolder: 'Write your comment...',
                        prefix: Container(
                            child: Icon(CupertinoIcons.text_alignleft)),
                        holderStyle: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[700])),
                        inputAction: TextInputAction.newline,
                        suffix: null,
                        readOnly: false,
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
        body: Center(
          child: Text("This is the Widget behind the sliding panel"),
        ),
      ),
    );
  }

  _showSingleChoiceDialog(BuildContext context) => Future.delayed(
        Duration.zero,
        () async {
          showDialog(
            context: context,
            builder: (context) {
              final _singleNotifier = Provider.of<SingleNotifier>(context);
              return AlertDialog(
                content: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _statuses
                          .getRange(3, 7)
                          .map((e) => RadioListTile(
                                title: Text(e.name),
                                value: e.name,
                                groupValue: _singleNotifier.currentStatus,
                                selected: _singleNotifier.currentStatus == e,
                                onChanged: (value) {
                                  if (value.toString() == 'unachieved') {
                                    _unachieved = true;
                                  } else {
                                    _unachieved = false;
                                  }
                                  _singleNotifier
                                      .updateStatus(value.toString());
                                  Navigator.of(context).pop();
                                  _statusValue = value.toString();
                                  setState(() {});
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );

  _header() {
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
                  label: 'Save',
                  color: Color(0xff915c83),
                  onTap: () {
                    _updateTask();
                    _editMode = false;
                    // setState(() {});
                    Get.to(() => Home());
                  })
            ],
          ),
        ),
      ],
    );
  }

  Widget buildStart() {
    final isRecording = false;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'Stop' : 'Start';
    return ElevatedButton.icon(
        onPressed: () async {},
        icon: Icon(icon),
        label: Text(text,
            style:
                GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold)));
  }

  void _updateTask() async {
    var data = {
      'status_name': _statusValue,
      'body': commentController.text,
    };
    print(data);
    var res =
        await Network().updateTaskSub(data, '/sub/tasks/${widget.task.id}');

    print(res);
    setState(() {});
  }
}
