import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_task2/screen/Home.dart';
import 'package:flutter_task2/widgets/button.dart';
import 'package:flutter_task2/widgets/sound_recorder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EditTaskSub extends StatefulWidget {
  const EditTaskSub({Key? key}) : super(key: key);

  @override
  _EditTaskSubState createState() => _EditTaskSubState();
}

class _EditTaskSubState extends State<EditTaskSub> {
  final recoder = SoundRecorder();
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
            children: [Center(child: buildStart())],
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
                    // _addTask();
                    // Get.to(Home());
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
}
