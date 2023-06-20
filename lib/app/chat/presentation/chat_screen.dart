import 'package:cord_2/app/chat/cubit/chat_cubit.dart';
import 'package:cord_2/app/chat/cubit/chat_states.dart';
import 'package:cord_2/app/chat/presentation/widgets/chat_app_bar.dart';
import 'package:cord_2/app/chat_details/presentation/view.dart';
import 'package:cord_2/core/user_api/controller/public_requests.dart';
import 'package:cord_2/core/user_api/model/user.dart';
import 'package:cord_2/core/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:search_page/search_page.dart';
import '../../../core/components/circular_button.dart';
import '../../../core/styles/colors.dart';
import 'widgets/chat_tile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<User> chatListUsers = [];

  _getChatList()  {
    BlocProvider.of<ChatCubit>(context).getChatList(PublicRequests.currentUser.phone)
        .then((value) {
      chatListUsers = PublicRequests.getCustomUser(BlocProvider.of<ChatCubit>(context).chatList);
      BlocProvider.of<ChatCubit>(context).chatList.clear();
    });

  }

  @override
  void initState() {
    super.initState();
    _getChatList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: SearchPage(
                    onQueryUpdate: print,
                    items: chatListUsers ,
                    searchLabel: 'Search',
                    suggestion: const Center(
                      child: Text('Filter chats by name'),
                    ),
                    failure: const Center(
                      child: Text('No chats found '),
                    ),
                    filter: (person) => [
                      person.name,
                    ],
                    builder: (person) => InkWell(
                      onTap: (){
                        navigateTo( ChatDetailsView(user: person.toJson()));
                      },
                      child: ListTile(
                        title: Text(person.name),
                        subtitle: Text(person.phone),
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: const [
                    Icon(Icons.search),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Search'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 19 / 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(width: 12.w),
                CircularButton(
                  height: 25.h,
                  width: 25.w,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const ChatDetailsView(
                      user: {
                        "id": 5,
                        "name": "Rana2",
                        "username": null,
                        "type": "patient",
                        "phone": "011452332322",
                        "image": null,
                        "email": "ranahesham78@gmail.com",
                      },
                    )));
                  },
                  child: Text(
                    chatListUsers.length.toString(),
                    style: TextStyle(color: AppColors.kWhite),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('New Group'),
                ),
              ],
            ),
            BlocBuilder<ChatCubit, ChatStates>(
              builder: (BuildContext ctx, state) => (state is ChatIsLoading)
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : (state is ChatErrorOccurred)
                  ? const Center(
                child: Text('There is an error occurred please try again later'),
              )
                  : (chatListUsers.isEmpty)
                  ? const Center(
                child: Text('You have not made any chat yet!'),
              )
                  : Expanded(
                child: ListView.separated(
                  itemCount: chatListUsers.length,
                  itemBuilder: (context, index) =>  ChatTile(user: chatListUsers[index].toJson()),
                  separatorBuilder: (context, index) => Divider(color: AppColors.kGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
