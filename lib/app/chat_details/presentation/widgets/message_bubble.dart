import 'package:cord_2/app/audio/presentaion/widgets/play_audio_widget.dart';
import 'package:cord_2/core/styles/colors.dart';
import 'package:cord_2/core/user_api/controller/public_requests.dart';
import 'package:cord_2/core/utils/constants.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final Map<String, dynamic> message;
  final String date;
  final String userPhone;
  final String type;

  const MessageBubble({super.key, required this.message, required this.isMe, required this.date, required this.type, required this.userPhone});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.topLeft : Alignment.topRight,
      child: UnconstrainedBox(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: sizeFromWidth(8),
            maxWidth: sizeFromWidth(1.3),
          ),
          child: (type == 'audio')
              ?  PlayAudioWidget(
                          isMe: (message['sendTo'] == PublicRequests.currentUser.phone) ? true : false,
                          message: message,
                          currentUserPhone: PublicRequests.currentUser.phone,
                          otherUserPhone: userPhone,
                )
              : Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(8),
                    topRight: const Radius.circular(8),
                    bottomLeft: Radius.circular(isMe ? 8 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 8),
                  ),
                  color: isMe ? const Color(0xFFEDEDED): const Color.fromRGBO(134, 143, 231, 0.4),
                ),
                child: Builder(builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Text(senderName, style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          type == 'text' ? (message['message'] ?? "") : 'مرفق',
                          style: TextStyle(
                            color: isMe ? AppColors.kWhite : AppColors.kBlack.withOpacity(0.6),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minWidth: sizeFromWidth(8),
                          maxWidth: sizeFromWidth(8),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            date,
                            style: TextStyle(
                              color: isMe ? AppColors.kWhite : AppColors.kBlack.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                              fontSize: (message.length > 10) ? 11 : 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
        ),
      ),
    );
  }
}
