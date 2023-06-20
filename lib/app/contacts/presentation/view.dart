import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:search_page/search_page.dart';

import '../../../core/components/gradient_button.dart';
import '../../../core/user_api/controller/public_requests.dart';
import '../../../core/utils/navigator.dart';
import '../../chat/cubit/chat_cubit.dart';
import '../../chat_details/presentation/view.dart';
import '../cubit/contact_cubit.dart';
import '../cubit/contact_states.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({Key? key}) : super(key: key);

  static Future<dynamic> get show => showModalBottomSheet(
        context: navigatorKey.currentContext!,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: _radius,
        ),
        builder: (context) {
          return const ContactsView();
        },
      );

  static BorderRadius get _radius => const BorderRadius.vertical(
        top: Radius.circular(8),
      );

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  _getContact() {
    BlocProvider.of<ContactCubit>(context).getContact();
  }

  @override
  void initState() {
    _getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: ContactsView._radius,
      ),
      builder: (context) {
        return UnconstrainedBox(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: ContactsView._radius,
            ),
            height: 550.h,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: SearchPage(
                          onQueryUpdate: print,
                          items: BlocProvider.of<ContactCubit>(context).contacts,
                          searchLabel: 'Search',
                          suggestion: const Center(
                            child: Text('Filter contact by name'),
                          ),
                          failure: const Center(
                            child: Text('No contact found '),
                          ),
                          filter: (person) => [
                            person.name.first,
                            person.name.last,
                          ],
                          builder: (person) => ListTile(
                            title: Text('${person.name.first} ${person.name.last}'),
                            subtitle: Text(person.phones.first.number),
                            trailing: BlocProvider.of<ContactCubit>(context).isUser(PublicRequests.allUsers, person.phones.first.number)
                                ? GradientButton(
                                    title: 'Add',
                                    width: 90,
                                    height: 30,
                                    fontSize: 16,
                                    onPressed: () {
                                      BlocProvider.of<ChatCubit>(context)
                                          .addToChat(PublicRequests.currentUser.phone, person.phones.first.number);
                                      Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(builder: (_)=>
                                               ChatDetailsView(user:  {
                                                "id": "5",
                                                "name": "${person.name.first} ${person.name.last}",
                                                "isPatient": true,
                                                "phone":  person.phones.first.number,
                                                "email": "ahmed123@gmail.com",
                                                "image": "https://th.bing.com/th/id/R.d51fab71c1c99bc56ef3b83699233c84?rik=G0vmJOfqp0D3Sg&pid=ImgRaw&r=0",
                                              },))
                                          , (route) => false);
                                    },
                                  )
                                : TextButton(
                                    child: const Text(
                                      'Invite',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onPressed: () async {
                                      await sendSMS(message: 'Hello my friend How are you ?', recipients: [person.phones.first.number]);
                                    },
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
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Your contacts:',
                      style: TextStyle(),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<ContactCubit, ContactStates>(
                      builder: (BuildContext ctx, state) => (state is ContactIsLoading)
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : (state is ContactIsLoaded)
                              ? ListView.separated(
                                  itemCount: state.contact.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text("${state.contact[index].name.first} ${state.contact[index].name.last}"),
                                      subtitle: Text(state.contact[index].phones.first.number),
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      trailing: BlocProvider.of<ContactCubit>(context)
                                              .isUser(PublicRequests.allUsers, state.contact[index].phones.first.number)
                                          ? GradientButton(
                                              title: 'Add',
                                              width: 90,
                                              height: 30,
                                              fontSize: 16,
                                              onPressed: () {
                                                BlocProvider.of<ChatCubit>(context)
                                                    .addToChat(PublicRequests.currentUser.phone, state.contact[index].phones.first.number);

                                                Navigator.pushAndRemoveUntil(context,
                                                    MaterialPageRoute(builder: (_)=>
                                                        ChatDetailsView(user: {
                                                          "id": "5",
                                                          "name": "Alaa Muhammad",
                                                          "isPatient": true,
                                                          "phone": state.contact[index].phones.first.number,
                                                          "email": "ahmed123@gmail.com",
                                                          "image":
                                                          "https://th.bing.com/th/id/R.d51fab71c1c99bc56ef3b83699233c84?rik=G0vmJOfqp0D3Sg&pid=ImgRaw&r=0",
                                                        },))
                                                    , (route) => false);

                                              },
                                            )
                                          : TextButton(
                                              child: const Text(
                                                'Invite',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              onPressed: () async {
                                                await sendSMS(
                                                    message: 'Hello my friend How are you ?', recipients: [state.contact[index].phones.first.number]);
                                              },
                                            ),
                                    );
                                  },
                                  separatorBuilder: (context, index) => const Divider(),
                                )
                              : (state is ContactAccessDeniedState)?
                      const Center(
                        child: Text('You should grant permission to access contact'),
                      )
                          :const Center(
                                  child: Text('There is an error occurred please try again later'),
                                ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
