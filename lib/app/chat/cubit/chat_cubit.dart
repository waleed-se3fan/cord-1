import 'package:cord_2/app/chat/cubit/chat_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitial());
  List<String> chatList = [];
  final CollectionReference<Map<String, dynamic>> chatListData = FirebaseFirestore.instance.collection('chatList');

  final CollectionReference<Map<String, dynamic>> notReadMessages = FirebaseFirestore.instance.collection('notReadMessages');

  final CollectionReference<Map<String, dynamic>> chats = FirebaseFirestore.instance.collection('chats');

  Future<void> getChatList(String currentUserPhone) async {
    emit(ChatIsLoading());
    try {
      QuerySnapshot<Map<String, dynamic>> response =
          await chatListData.doc(currentUserPhone).collection(currentUserPhone).orderBy('createdAt', descending: true).get();
      if (response.docs.isNotEmpty) {
        for (var element in response.docs) {
          chatList.add(element.data()['phone']);
        }
      }
      emit(ChatListIsLoaded());
    } catch (e) {
      emit(ChatErrorOccurred());
    }
  }

  addToChat(String currentUserPhone, String otherUserPhone) async {
    emit(ChatIsLoading());
    try {
      await chatListData.doc(currentUserPhone).collection(currentUserPhone).doc(otherUserPhone).set({
        "phone": otherUserPhone,
        "createdAt": Timestamp.now(),
      });
      await chatListData.doc(otherUserPhone).collection(otherUserPhone).doc(currentUserPhone).set({
        "phone": currentUserPhone,
        "createdAt": Timestamp.now(),
      });
      emit(ChatIsAdded());
    } catch (e) {
      emit(ChatErrorOccurred());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotReadMessages(String currentUserPhone, String otherUserPhone) {
    return notReadMessages.doc(currentUserPhone).collection(otherUserPhone).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(String currentUserPhone, String otherUserPhone)  {
    return chats.doc(currentUserPhone).collection(otherUserPhone).orderBy('createdAt', descending: true).limit(1).snapshots();
  }
}
