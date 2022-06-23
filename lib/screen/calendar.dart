import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_task2/models/Task.dart';
import 'package:flutter_task2/screen/Home.dart';
import 'package:flutter_task2/screen/edit_task_sub.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:flutter_task2/widgets/Cupertino_input_field.dart';
import 'package:flutter_task2/widgets/build_bottom_sheet_show_task.dart';
import 'package:flutter_task2/widgets/dialogue_delete.dart';
import 'package:flutter_task2/widgets/shimmer_widget.dart';
import 'package:flutter_task2/widgets/slidable_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

typedef bool HasSameHeader(int a, int b);

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<Task> _tasks1 = [];
  List<Task> _tasks2 = [];
  List<Task> _tasks = [];
  late Future data;
  late Future data2;
  List<String> _titles = [];
  int currentPosition = 0;
  String scroll = '';
  int _todoLength = 0;

  _getAllTasks() async {
    var res = await Network().getTaskData('/users/tasks').then((tasks) {
      if (mounted) {
        setState(() {
          _tasks = tasks;
          for (var i = 0; i < _tasks.length; i++) {
            // print(_tasks[i]);
            _titles.add(_tasks[i].title);
            // _tasks.add(_tasks[i]);
          }
          _tasks.sort((a, b) {
            return (a.deadline == null ? DateTime.now() : a.deadline)!
                .compareTo(b.deadline ?? DateTime.now());
          });

          // _titles = _tasks.map((e) => e.title).toList();
        });
      }
    });
    return _tasks;
  }

  _getTodoList() async {
    var res = await Network().getTaskData('/users/admins/tasks').then((tasks1) {
      if (mounted) {
        setState(() {
          _tasks1 = tasks1;
          // _tasks = _tasks1;
          _todoLength = _tasks1.length;
          // for (var i = 0; i < _tasks1.length; i++) {
          //   print(_tasks1[i]);
          //   // _titles.add(_tasks1[i].title);
          // }

          // _titles = _tasks.map((e) => e.title).toList();
        });
      }
    });
    return _tasks1;
  }

  // _getSentList() async {
  //   var res = await Network().getTaskData('/users/subs/tasks').then((tasks2) {
  //     setState(() {
  //       _tasks2 = tasks2;
  //       // for (var i = 0; i < _tasks2.length; i++) {
  //       //   print(_tasks2[i]);
  //       //   // _titles.add(_tasks2[i].title);
  //       //   // _tasks.add(_tasks2[i]);
  //       // }

  //       // _titles = _tasks.map((e) => e.title).toList();
  //     });
  //   });
  //   return _tasks2;
  // }

  @override
  void initState() {
    super.initState();

    data = _getAllTasks();
    data2 = _getTodoList();
    // _getSentList();
    _tasks1;
    _tasks2;
    _tasks;
    _titles;
    _todoLength;
    // print(_todoLength);
  }

  @override
  void dispose() {
    super.dispose();
    _getScrollController().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 18),
            child: Stack(
              children: <Widget>[
                FutureBuilder(
                    future: data,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return new Positioned(
                          child: new Opacity(
                            opacity:
                                !_shouldShowHeader(currentPosition) ? 0.0 : 1.0,
                            child: headerBuilder(context,
                                currentPosition >= 0 ? currentPosition : 0),
                          ),
                          top: 0.0 + (EdgeInsets.all(16.0).top),
                          left: 0.0 + (EdgeInsets.all(16.0).left),
                        );
                      } else {
                        return Center(
                          child: SpinKitRotatingPlain(
                            color: Color(0xff665C84),
                          ),
                        );
                      }
                    }),
                new ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: _tasks.length,
                    controller: _getScrollController(),
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new FittedBox(
                            // FittedBox, this will resize your text according to available area.
                            child: new Opacity(
                              opacity: !_shouldShowHeader(index) ? 1.0 : 0.0,
                              child: headerBuilder(context, index),
                            ),
                          ),
                          new Expanded(child: itemBuilder(context, index))
                        ],
                      );
                    }),
              ],
            ),
          ),
        ));
  }

  bool hasSameHeader(int a, int b) {
    Task task1 = _tasks[a];
    Task task2 = _tasks[b];
    return task1.deadline == task2.deadline;
  }

  bool _shouldShowHeader(int position) {
    if (position < 0) {
      return true;
    }
    if (position == 0 && currentPosition < 0) {
      return true;
    }

    if (position != 0 &&
        position != currentPosition &&
        hasSameHeader(position, position - 1)) {
      return true;
    }

    if (position != _titles.length - 1 &&
        hasSameHeader(position, position + 1) &&
        position == currentPosition) {
      return true;
    }
    return false;
  }

  headerBuilder(BuildContext context, int index) {
    Task task = _tasks[index];
    return new SizedBox(
      width: 32.0,
      child: Column(
        children: [
          new Text(
            DateFormat.E().format(task.deadline ?? DateTime.now()),
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400)),
          ),
          ClipOval(
            child: Container(
              height: 30,
              width: 30,
              color: Color(0xfffbceb1),
              child: Center(
                child: new Text(
                  DateFormat.d().format(task.deadline ?? DateTime.now()),
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ScrollController _getScrollController() {
    var controller = new ScrollController();
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.reverse) {
        // print('scrolled down');
        if (this.mounted) {
          setState(() {
            scroll = 'down';
          });
        }
      } else if (controller.position.userScrollDirection ==
          ScrollDirection.forward) {
        // print('scrolled up');
        if (this.mounted) {
          setState(() {
            scroll = 'up';
          });
        }
      }
    });
    return controller;
  }

  bool _isItTodo(int i) {
    return _tasks1.map((t) => t.id).toList().contains(_tasks[i].id);
  }

  itemBuilder(BuildContext context, int index) {
    Task task = _tasks[index];
    return FutureBuilder(
        future: data2,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                VisibilityDetector(
                  key: Key(index.toString()),
                  onVisibilityChanged: (visibilityInfo) {
                    if (scroll == 'down') {
                      if (visibilityInfo.visibleFraction == 0) if (this
                          .mounted) {
                        setState(() {
                          currentPosition = index;
                          print(currentPosition);
                          print(scroll);
                        });
                      }
                    } else if (scroll == 'up') {
                      if (visibilityInfo.visibleFraction == 1) if (mounted) {
                        setState(() {
                          currentPosition = index;
                          print('$index ${visibilityInfo.visibleFraction}');
                          print(currentPosition);
                          print(scroll);
                        });
                      }
                    }
                  },
                  child: GestureDetector(
                    onTap: () {
                      bottomSheet(context, task, index, _isItTodo(index));
                    },
                    child: SlidableWidget(
                      onSlided: () async {
                        if (_isItTodo(index)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'You don\'t have the permission to delete this task'),
                            ),
                          );
                        } else {
                          final result = await showDialog(
                              context: context,
                              builder: (_) => DeleteDialogue());
                          if (result) {
                            _deleteTask(task.id);
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => Home()));
                          }
                        }
                      },
                      background: buildBackground(index),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 64.0,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _isItTodo(index)
                              ? Color(0xff9966cc)
                              : Color(0xffcc9966),
                          border: Border.all(
                              color: _isItTodo(index)
                                  ? Color(0xff9966cc)
                                  : Color(0xffcc9966),
                              width: 3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          task.title,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ),
                  ),
                ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: index < _tasks.length - 1
                      ? (hasSameHeader(index, index + 1) ? 5 : 25)
                      : 5,
                )
              ],
            );
          } else {
            return
                // LinearProgressIndicator();
                ShimmerWidget.rectangular(
              width: MediaQuery.of(context).size.width - 64.0,
              height: 37,
              isCircularShape: false,
            );
          }
          ;
        });
  }

  Future bottomSheet(
      BuildContext context, Task task, int index, bool isItTodo) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(80))),
      context: context,
      builder: (context) => isItTodo
          ? BuildBottomSheet(
              task: task,
              isItTodo: true,
            )
          : BuildBottomSheet(
              task: task,
              isItTodo: false,
            ),
    );
  }

  buildBackground(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        // border: Border.all(
        //     // color: _isItTodo(index) ? Color(0xff9966cc) : Color(0xffcc9966),
        //     width: 3),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Icon(
        Icons.delete,
        size: 32,
        color: _isItTodo(index) ? Color(0xff9966cc) : Color(0xffcc9966),
      ),
    );
  }

  void _deleteTask(String taskId) async {
    var res = await Network().DeleteTask(taskId);
    print(res);
  }
}
