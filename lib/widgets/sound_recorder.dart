import 'package:flutter_sound/flutter_sound.dart';

final pathToSaveAudio = 'audio_exemple.aac';

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;

  Future _record() async {
    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future _stop() async {
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
