import 'package:cord_2/app/chat_details/cubit/chat_details_cubit.dart';
import 'package:cord_2/app/layout/presentation/cord_layout.dart';
import 'package:cord_2/core/styles/colors.dart';
import 'package:cord_2/core/user_api/controller/public_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatDetailsAppBar({Key? key,required this.user}) : super(key: key);
  final Map<String,dynamic> user ;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 55,
      centerTitle: false,
      titleSpacing: -10,
      elevation: 5.0,
      title: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.kPurple,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: (user['image']!= null)?Image.network(user['image'],fit: BoxFit.fill,):const Icon(Icons.person),
            ) ,
          ),
          const SizedBox(width: 8),
          Text(
            user['name'],
            style: TextStyle(
              color: AppColors.kBlack,
              fontSize: 16,
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: (){
          BlocProvider.of<ChatDetailsCubit>(context).clearNotReadMessages(PublicRequests.currentUser.phone, user['phone']);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const CordLayout()));
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
