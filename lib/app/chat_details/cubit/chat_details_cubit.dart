import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cord_2/app/chat_details/cubit/chat_details_states.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
class ChatDetailsCubit extends Cubit<ChatDetailsStates> {
  ChatDetailsCubit() : super(ChatDetailsInitial());

  final CollectionReference<Map<String, dynamic>> chats = FirebaseFirestore.instance.collection('chats');

  final CollectionReference<Map<String, dynamic>> notReadMessages = FirebaseFirestore.instance.collection('notReadMessages');

  final records = FirebaseStorage.instance;

  final FlutterTts flutterTts = FlutterTts();

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String currentUserPhone, String otherUserPhone) {
    Stream<QuerySnapshot<Map<String, dynamic>>> response =
        chats.doc(currentUserPhone).collection(otherUserPhone).orderBy('createdAt', descending: true).snapshots();
    return response;
  }

  Future<void> sendMessage(
    String message,
    String currentUserPhone,
    String otherUserPhone, {
    String type = 'text',
        String ? audioLocalPath,
  }) async {
    emit(ChatDetailsSendingMessage());
    final String key = UniqueKey().toString();
    try {
      await chats.doc(currentUserPhone).collection(otherUserPhone).doc(key).set({
        "id":key,
        "message": (type == 'text')?message:audioLocalPath,
        "createdAt": Timestamp.now(),
        "sendTo": otherUserPhone,
        "type": type,
        "isDownloaded":(type == 'text') ? null : true ,
      });
      await chats.doc(otherUserPhone).collection(currentUserPhone).doc(key).set({
        "id":key,
        "message": message,
        "createdAt": Timestamp.now(),
        "sendTo": otherUserPhone,
        "type": type,
      });
      emit(ChatDetailsIsSent());
      _updateNotReadMessages(currentUserPhone, otherUserPhone);
    } catch (e) {
      debugPrint(e.toString());
      emit(ChatDetailsSendingError());
    }
  }

  _updateNotReadMessages(String currentUserPhone, String otherUserPhone) async {
    await notReadMessages.doc(otherUserPhone).collection(currentUserPhone).doc(currentUserPhone).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        notReadMessages.doc(otherUserPhone).collection(currentUserPhone).doc(currentUserPhone).update({
          "unReadMessages": FieldValue.increment(1),
        });
      } else {
        notReadMessages.doc(otherUserPhone).collection(currentUserPhone).doc(currentUserPhone).set({
          "unReadMessages": FieldValue.increment(1),
        });
      }
    });
  }

  Future<void> clearNotReadMessages(String currentUserPhone, String otherUserPhone) async {
    await notReadMessages.doc(currentUserPhone).collection(otherUserPhone).doc(otherUserPhone).set({
      "unReadMessages": 0,
    });
  }

  sendPatientRecord( String currentUserPhone, String otherUserPhone,String token) async {
    http.Response response = await http.post(Uri.parse('https://cord0.me/api/signals/simulate',),headers: {
      'Authorization':'Bearer $token',
    });
     String message = response.body ;
    await flutterTts.setLanguage('ar');
    await flutterTts.setLanguage('ar');
    await flutterTts.setLanguage('en-US');
    final String key = UniqueKey().toString().replaceAll('#', '');
    Directory? dir = await getExternalStorageDirectory();
    await flutterTts.synthesizeToFile(message, '$key.aac');
    sendAssistantRecord('${dir!.path}/$key.aac', currentUserPhone, otherUserPhone);
  }

  sendAssistantRecord( String path, String currentUserPhone, String otherUserPhone,) {
    emit(ChatDetailsSendingRecord());
    final String key = UniqueKey().toString().replaceAll('#', '');
    try {
      records.ref('records/$key').putFile(File(path));
      String message = records.ref('records/$key').fullPath;
      sendMessage(message, currentUserPhone, otherUserPhone, type: 'audio',audioLocalPath:path);
      emit(ChatDetailsIsSent());
    } catch (e) {
      emit(ChatDetailsSendingError());
    }
  }

  sendRecord(String path, String currentUserPhone, String otherUserPhone,String type,String token){
    if(type == 'patient'){
      sendPatientRecord(currentUserPhone, otherUserPhone,token);
    }else{
      sendAssistantRecord(path, currentUserPhone, otherUserPhone);
    }
  }

  downloadRecord(Map<String,dynamic> message,String currentUserPhone, String otherUserPhone,{isRecent = false})
  async {
    if(!isRecent){
      emit(ChatDetailsRecordIsDownloading());
    }
    if(message['isDownloaded'] == true){
      return ;
    }
    final Directory dir = await getApplicationDocumentsDirectory();
    final String trackName = records.ref(message['message']).name;
    await records.ref(message['message']).writeToFile(File('${dir.path}/$trackName.aac'));
    await chats.doc(currentUserPhone).collection(otherUserPhone).doc(message['id']).update({
      "message": '${dir.path}/$trackName.aac',
      "isDownloaded":true ,
    });
    emit(ChatDetailsRecordIsDownloaded());

  }
}
