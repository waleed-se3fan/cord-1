import 'dart:async';

import 'package:cord_2/app/audio/cubit/audio_cubit.dart';
import 'package:cord_2/app/audio/cubit/audio_states.dart';
import 'package:cord_2/app/chat_details/cubit/chat_details_cubit.dart';
import 'package:cord_2/app/login/login_cubit/login_cubit.dart';
import 'package:cord_2/app/signup/signup_cubit/cubit.dart';
import 'package:cord_2/core/user_api/controller/public_requests.dart';
import 'package:cord_2/core/components/circular_button.dart';
import 'package:cord_2/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailsFooter extends StatefulWidget {
  const ChatDetailsFooter({Key? key, required this.user}) : super(key: key);
  final Map<String, dynamic> user;

  @override
  State<ChatDetailsFooter> createState() => _ChatDetailsFooterState();
}

class _ChatDetailsFooterState extends State<ChatDetailsFooter> {
  final TextEditingController _textController = TextEditingController();

  bool isAudio = false;

  Timer _timer = Timer(Duration.zero,(){}) ;
  String _recordDuration = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.fromLTRB(
        0,
        20,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.kLightGrey,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.centerRight ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      width: (isAudio)
                          ? MediaQuery.of(context).size.width * .85
                          : MediaQuery.of(context).size.width * .7,
                      child: TextFormField(
                        controller: _textController,
                        cursorHeight: 15,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColors.kWhite,
                          filled: true,
                          hintText: isAudio ? 'Slid to cancel >' : 'Write Something',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                          constraints: const BoxConstraints(
                            minHeight: 35,
                            maxHeight: 35,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.kWhite,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.circular(24)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.kWhite,
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          suffixIcon:(isAudio)? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_recordDuration,style: const TextStyle(color: Colors.black),),
                              Container(
                                  margin: const EdgeInsets.only(left: 5,right: 10),
                                  width: 20,
                                  height: 20,
                                  child: Image.asset('assets/icons/recording_icon.png',fit: BoxFit.fill,),
                              ),
                            ],
                          ):null,
                        ),
                      ),
                    ),
                    if(!isAudio)
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .15 ,
                          child: CircularButton(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            BlocProvider.of<ChatDetailsCubit>(context)
                                  .sendMessage(_textController.text, PublicRequests.currentUser.phone, widget.user['phone']);
                              _textController.clear();
                              },
                          child: Icon(
                            Icons.send,
                            size: 17,
                            color: AppColors.kWhite,
                          ),
                    ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width:MediaQuery.of(context).size.width * .15,
                height: 45,
                child: BlocBuilder<AudioCubit, AudioStates>(builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      if(state is AudioRecordStarted){
                        BlocProvider.of<AudioCubit>(context).stopRecord();
                        BlocProvider.of<ChatDetailsCubit>(context)
                            .sendRecord(BlocProvider.of<AudioCubit>(context).path!, PublicRequests.currentUser.phone,
                            widget.user['phone'], PublicRequests.currentUser.type ,
                            (LoginCubit.token.isNotEmpty)?LoginCubit.token: SignUpCubit.token);
                        _timer.cancel();
                        setState(() {
                          isAudio = false;
                          _recordDuration = '';
                         });
                      }
                      else{
                        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                          setState(() {
                            _recordDuration = '${timer.tick~/60} : ${timer.tick % 60}';
                          });
                        });
                        setState(() {
                          isAudio = true;
                        });
                        BlocProvider.of<AudioCubit>(context).startRecord();
                      }
                    },
                    onHorizontalDragStart: (onHorizontalDragStartDetails){
                      _timer.cancel();
                      BlocProvider.of<AudioCubit>(context).stopRecord();
                      setState(() {
                        isAudio = false ;
                        _recordDuration = '';
                        });
                    },
                    child: Container(
                      margin:isAudio
                          ?  const EdgeInsets.only(left: 10,bottom: 10)
                          : const EdgeInsets.only(),
                      child: AnimatedScale(
                        scale:!isAudio? 1:1.7,
                        duration: const Duration(milliseconds: 300),
                        child: Material(
                          elevation:isAudio? 10:0,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isAudio? Colors.white: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            width: 60 ,
                            height: 60,
                            child:Image.asset('assets/icons/record_audio_icon.png',),
                          ),
                        ) ,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}
