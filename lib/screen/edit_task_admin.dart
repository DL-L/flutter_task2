import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_task2/models/Task.dart';
import 'package:flutter_task2/screen/Home.dart';
import 'package:flutter_task2/service/api.dart';
import 'package:flutter_task2/widgets/Cupertino_input_field.dart';
import 'package:flutter_task2/widgets/button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EditTaskAdmin extends StatefulWidget {
  final Task task;
  const EditTaskAdmin({required this.task, Key? key}) : super(key: key);

  @override
  _EditTaskAdminState createState() => _EditTaskAdminState();
}

class _EditTaskAdminState extends State<EditTaskAdmin> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late DateTime _date = widget.task.deadline!;

  // @override
  // void initState() {
  //   super.initState();
  //   // DateTime _date = widget.task.deadline!;
  // }

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
              CupertinoField(
                controller: titleController,
                expands: false,
                inputtype: TextInputType.text,
                maxlines: 1,
                minlines: 1,
                placeHolder: widget.task.title,
                prefix: SizedBox(
                  width: 25,
                ),
                holderStyle: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700])),
                inputAction: TextInputAction.next,
                suffix: null,
                readOnly: false,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CupertinoField(
                controller: descriptionController,
                expands: true,
                inputtype: TextInputType.multiline,
                maxlines: null,
                minlines: null,
                placeHolder: widget.task.description,
                prefix: Container(child: Icon(CupertinoIcons.text_alignleft)),
                holderStyle: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700])),
                inputAction: TextInputAction.newline,
                suffix: null,
                readOnly: false,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Container(
                      // color: Colors.amber,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 8.0, left: 50),
                      child: Text(
                        DateFormat.E().format(_date) +
                            ', ' +
                            DateFormat.LLL().format(_date) +
                            ' ' +
                            DateFormat.d().format(_date) +
                            ', ' +
                            DateFormat.y().format(_date),
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                      ),
                    ),
                    onTap: () {
                      _getDateFromUser();
                    },
                  )
                ],
              ),
            ],
          )),
        ),
        body: Center(
          child: Text("This is the Widget behind the sliding panel"),
        ),
      ),
    );
  }

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
                    null;
                    _updateTask();
                    Get.to(Home());
                  })
            ],
          ),
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showRoundedDatePicker(
        height: 305,
        context: context,
        borderRadius: 16,
        theme: ThemeData.dark(),
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1));

    if (_pickerDate != null) {
      setState(() {
        _date = _pickerDate;
      });
    } else {
      print('its null');
    }
  }

  void _updateTask() async {
    var data = {
      'title': titleController.text,
      'description': descriptionController.text,
      'deadline': _date.toString()
    };

    var res =
        await Network().updateTaskAdmin(data, '/admin/tasks/${widget.task.id}');

    print(res);
  }
}
