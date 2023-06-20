
import 'package:cord_2/app/contacts/cubit/contact_states.dart';
import 'package:cord_2/core/user_api/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactCubit extends Cubit<ContactStates> {

  ContactCubit():super(ContactInitialState());

  List<Contact>  contacts = [] ;

  getContact() async {
    emit(ContactIsLoading());
    try{
      if(await Permission.contacts.request().isGranted){
        contacts = await FlutterContacts.getContacts(withProperties: true );
        emit(ContactIsLoaded(contacts));
      }else{
        emit(ContactAccessDeniedState());
      }
    }catch (e){
      emit(ContactErrorOccurred());
    }

  }

  bool isUser(List<User> users,String phone){
    return users.any((element) => element.phone== phone);
  }
}