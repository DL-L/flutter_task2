import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task2/models/Task.dart';
import 'package:flutter_task2/widgets/Cupertino_input_field.dart';
import 'package:flutter_task2/widgets/input_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TaskForm extends StatefulWidget {
  final Widget header;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController phoneController;
  final String type;
  final String selectedUser;
  final String value;
  final Task? task;
  final DateTime date;
  final Function function;
  final Function(String?) onChanged;
  final List<DropdownMenuItem<String>>? items;
  const TaskForm(
      {required this.header,
      required this.titleController,
      required this.descriptionController,
      required this.phoneController,
      required this.type,
      required this.task,
      required this.date,
      required this.function,
      required this.items,
      required this.selectedUser,
      required this.value,
      required this.onChanged,
      Key? key})
      : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  String? value;
  String _selectedUser = 'None';
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropEnabled: true,
      parallaxEnabled: true,
      slideDirection: SlideDirection.UP,
      defaultPanelState: PanelState.OPEN,
      maxHeight: MediaQuery.of(context).size.height,
      header: widget.header,
      panel: Container(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoField(
              controller: widget.titleController,
              expands: false,
              inputtype: TextInputType.text,
              maxlines: 1,
              minlines: 1,
              placeHolder:
                  widget.type == 'add' ? 'Add Title' : widget.task!.title,
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
              controller: widget.descriptionController,
              expands: true,
              inputtype: TextInputType.multiline,
              maxlines: null,
              minlines: null,
              placeHolder: widget.type == 'add'
                  ? 'Add description'
                  : widget.task!.description,
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
                      DateFormat.E().format(widget.date) +
                          ', ' +
                          DateFormat.LLL().format(widget.date) +
                          ' ' +
                          DateFormat.d().format(widget.date) +
                          ', ' +
                          DateFormat.y().format(widget.date),
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ),
                  ),
                  onTap: () {
                    widget.function();
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35),
              child: InputField(
                  title: null,
                  hint: widget.selectedUser,
                  controller: widget.phoneController,
                  widget: DropdownButton<String>(
                    value: widget.value,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blueGrey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: widget.onChanged,
                    items: widget.items,
                  )),
            ),
          ],
        )),
      ),
      body: Center(
        child: Text("This is the Widget behind the sliding panel"),
      ),
    );
  }
}
