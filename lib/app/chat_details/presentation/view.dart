import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cord_2/app/audio/cubit/audio_cubit.dart';
import 'package:cord_2/app/chat_details/cubit/chat_details_cubit.dart';
import 'package:cord_2/app/chat_details/presentation/widgets/app_bar.dart';
import 'package:cord_2/app/chat_details/presentation/widgets/footer.dart';
import 'package:cord_2/app/chat_details/presentation/widgets/message_bubble.dart';
import 'package:cord_2/core/user_api/controller/public_requests.dart';
import 'package:cord_2/core/helper/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailsView extends StatefulWidget {
  const ChatDetailsView({Key? key, required this.user}) : super(key: key);
  final Map<String, dynamic> user;
  static bool x = false ;
  @override
  State<ChatDetailsView> createState() => _ChatDetailsViewState();
}

class _ChatDetailsViewState extends State<ChatDetailsView> {
  _clearNotReadMessages() {
    BlocProvider.of<ChatDetailsCubit>(context).clearNotReadMessages(PublicRequests.currentUser.phone, widget.user['phone']);
  }
  void _defineAudio() {
    BlocProvider.of<AudioCubit>(context).initAudio();
  }
  _disposeAudio(){
    BlocProvider.of<AudioCubit>(context).disposeAudio();
  }
  @override
  void initState() {
    super.initState();
    _defineAudio();
    _clearNotReadMessages();
  }
  @override
  void dispose() {
    super.dispose();
    _disposeAudio();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatDetailsAppBar(
        user: widget.user,
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: BlocProvider.of<ChatDetailsCubit>(context).getMessages(PublicRequests.currentUser.phone, widget.user['phone']),
              builder: (context, snapshot) => (snapshot.hasError)
                  ? const Center(
                      child: Text('There is an error occurred please try again later!'),
                    )
                  : (snapshot.data == null || snapshot.data!.size == 0)
                  ? const Center(
                          child: Text('There is no messages!'),
                        )
                      : (snapshot.connectionState != ConnectionState.active)
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: snapshot.data!.size,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              reverse: true,
                              itemBuilder: (context, index) => MessageBubble(
                                isMe: (snapshot.data!.docs[index]['sendTo'] == PublicRequests.currentUser.phone) ? true : false,
                                message: snapshot.data!.docs[index].data(),
                                date: DateTimeHelper.getDateFormat(snapshot.data!.docs[index]['createdAt'].toDate()),
                                type: snapshot.data!.docs[index]['type'],
                                userPhone: widget.user['phone'],
                              ),
                            ),
            ),
          ),
           ChatDetailsFooter(user: widget.user,),
        ],
      ),
    );
  }
}


