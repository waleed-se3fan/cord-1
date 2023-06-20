
import 'dart:io';

import 'package:cord_2/app/audio/cubit/audio_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';

class AudioCubit extends Cubit<AudioStates>{
  AudioCubit():super(AudioInitialingState());

  late final RecorderController recorderController ;
  late Directory appDirectory ;
  String ? path;
  Duration audioDuration = Duration.zero;

  initAudio() async {
    emit(AudioInitialingState());
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100 ;
    appDirectory = await getApplicationDocumentsDirectory();
    emit(AudioIsInitialedState());
  }

  disposeAudio(){
    recorderController.dispose();
    emit(AudioIsDisposed());
  }

  startRecord() {
    final String key = UniqueKey().toString().replaceAll('#', '');
    path = '${appDirectory.path}/$key.aac';
    recorderController.record(path: path );
    emit(AudioRecordStarted());
  }
  pauseRecord(){
    recorderController.pause();
    emit(AudioRecordPaused());
  }
  stopRecord(){
    recorderController.stop();
    audioDuration = recorderController.recordedDuration ;
    emit(AudioRecordStopped());
  }

  playAudio(String path, PlayerController playerController)  async{
    File file = File(path);
    await playerController.preparePlayer(
      path: file.path ,
      shouldExtractWaveform: true,
    );

    await playerController.startPlayer(finishMode: FinishMode.loop);
    emit(AudioPlayerStarted());
    playerController.onCompletion.listen((event) {
      stopAudio(playerController);
    });
  }


  stopAudio( PlayerController playerController) async {
    await playerController.stopPlayer() ;
    emit(AudioPlayerStopped());
  }

  Future<String> getDuration(PlayerController playerController) async {
    Duration duration =  Duration(milliseconds: await playerController.getDuration(DurationType.max));
    return '${duration.inMinutes} : ${duration.inSeconds}';
  }

}