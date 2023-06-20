import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cord_2/app/audio/cubit/audio_cubit.dart';
import 'package:cord_2/app/audio/cubit/audio_states.dart';
import 'package:cord_2/app/chat_details/cubit/chat_details_cubit.dart';
import 'package:cord_2/app/chat_details/cubit/chat_details_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayAudioWidget extends StatefulWidget {
  PlayAudioWidget({Key? key, required this.isMe, required this.message, required this.currentUserPhone, required this.otherUserPhone})
      : super(key: key);
  bool isMe;
  Map<String, dynamic> message;

  String currentUserPhone;

  String otherUserPhone;

  @override
  State<PlayAudioWidget> createState() => _PlayAudioWidgetState();
}

class _PlayAudioWidgetState extends State<PlayAudioWidget> {
  late final PlayerController _playerController;

  _downloadRecord({isRecent = false}) {
    BlocProvider.of<ChatDetailsCubit>(context).downloadRecord(widget.message, widget.currentUserPhone, widget.otherUserPhone, isRecent: isRecent);
  }

  @override
  void initState() {
    _playerController = PlayerController();
    if (widget.message['isDownloaded'] == null || widget.message['isDownloaded'] == false) {
      _downloadRecord();
    }
    super.initState();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 6,
        right: widget.isMe ? 0 : 10,
        top: 10,
      ),
      height: 65 ,
      margin: const EdgeInsets.symmetric(vertical: 8,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: !widget.isMe ? const Color.fromRGBO(134, 143, 231, 0.4) : const Color(0xFFEDEDED),
      ),
      child: BlocBuilder<ChatDetailsCubit, ChatDetailsStates>(
        builder: (ctx, chatDetailsState) => (chatDetailsState is ChatDetailsRecordIsDownloading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : BlocBuilder<AudioCubit, AudioStates>(
                builder: (cont, audioStates) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () async{
                        if (!widget.message['message'].contains('.aac')) {
                          _downloadRecord(isRecent: true);
                        }
                        if (audioStates is AudioPlayerStarted) {
                          await BlocProvider.of<AudioCubit>(context).stopAudio(_playerController);
                        } else {
                          await BlocProvider.of<AudioCubit>(context).playAudio(widget.message['message'], _playerController);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        width: 29,
                        height: 29,
                        decoration:const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child:  Icon(
                            (_playerController.playerState.isPlaying) ? Icons.stop : Icons.play_arrow,
                            color: !widget.isMe ? const Color(0xFF9DD3CF) : const Color.fromRGBO(0, 0, 0, .6),
                          ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (_playerController.playerState.isStopped)
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 42,
                            child:(widget.isMe)
                                ? Image.asset('assets/icons/audio_wave_black.png')
                                :Image.asset('assets/icons/audio_wave_white.png'),
                          ),
                        if (!_playerController.playerState.isStopped)
                          AudioFileWaveforms(
                            size: Size(MediaQuery.of(context).size.width / 2, 30),
                            playerController: _playerController,
                            waveformType: WaveformType.long,
                            playerWaveStyle: const PlayerWaveStyle(
                              fixedWaveColor: Colors.white54,
                              liveWaveColor: Colors.white,
                              spacing: 6,
                              waveCap: StrokeCap.square
                            ),
                          ),
                        if (!_playerController.playerState.isStopped)
                          Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(),
                            child: FutureBuilder(
                                future: BlocProvider.of<AudioCubit>(context).getDuration(_playerController),
                                builder: (context, snapShot) {
                                  return Text(
                                    (snapShot.data == null) ? '' : snapShot.data!,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: !widget.isMe ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                          ),
                      ],
                    ),
                    if (widget.isMe) const SizedBox(width: 10),
                  ],
                ),
              ),
      ),
    );
  }
}
