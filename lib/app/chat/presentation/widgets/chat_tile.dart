import 'package:cord_2/app/chat/cubit/chat_cubit.dart';
import 'package:cord_2/core/helper/date_time_helper.dart';
import 'package:cord_2/core/user_api/controller/public_requests.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/styles/colors.dart';
import '../../../../core/utils/navigator.dart';
import '../../../chat_details/presentation/view.dart';

class ChatTile extends StatelessWidget {
  ChatTile({Key? key, required this.user}) : super(key: key);
  Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      direction: Axis.horizontal,
      dragStartBehavior: DragStartBehavior.start,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.4,
        children: [
          const SizedBox(width: 5),
          Container(
            width: 61.w,
            height: 57.h,
            color: AppColors.kGrey.withOpacity(0.78),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.more_horiz, color: AppColors.kWhite),
                Text('More', style: TextStyle(color: AppColors.kWhite, fontSize: 12)),
              ],
            ),
          ),
          Container(
            width: 61.w,
            height: 57.h,
            color: AppColors.kPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.archive_outlined, color: AppColors.kWhite),
                Text('Archive', style: TextStyle(color: AppColors.kWhite, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => navigateTo(ChatDetailsView(user: user)),
        child: SizedBox(
          height: 50.h,
          child: StreamBuilder(
            stream: BlocProvider.of<ChatCubit>(context).getLastMessage(PublicRequests.currentUser.phone
                , user['phone']),
            builder: (context, lastMessageSnapShot) =>
                Row(
                  children: [
                    Container(
                      height: 47.h,
                      width: 47.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            user['image'],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user['name'],
                            style: TextStyle(
                              color: AppColors.kBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            (lastMessageSnapShot.hasError || lastMessageSnapShot.data == null)
                                ? ''
                                : (lastMessageSnapShot.data!.docs.first.data()['type']== 'audio')
                                ? 'Audio File':lastMessageSnapShot.data!.docs.first.data()['message'],
                            style: TextStyle(
                              color: AppColors.kGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (lastMessageSnapShot.hasError || lastMessageSnapShot.data == null)
                              ? ''
                              : DateTimeHelper.getDateDifference(lastMessageSnapShot.data!.docs.first.data()['createdAt'].toDate()),
                          style: TextStyle(
                            color: AppColors.kPurple,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        StreamBuilder(
                          stream: BlocProvider.of<ChatCubit>(context).getNotReadMessages(PublicRequests.currentUser.phone, user['phone']),
                          builder: (ctx, snapShot) =>
                          (snapShot.hasError || snapShot.data == null ||snapShot.data!.docs.first.data()['unReadMessages']==0)
                              ? Container()
                              : CircleAvatar(
                              radius: 13,
                              backgroundColor: AppColors.kPurple,
                              child: Text(snapShot.data!.docs.first.data()['unReadMessages'].toString(), style: TextStyle(color:
                              AppColors.kWhite),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
