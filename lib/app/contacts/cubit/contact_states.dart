
import 'package:flutter_contacts/flutter_contacts.dart';

abstract class ContactStates {}

class ContactInitialState extends ContactStates {}


class ContactIsLoading extends ContactStates {}

class ContactErrorOccurred extends ContactStates {}
class ContactAccessDeniedState extends ContactStates {}


class ContactIsLoaded extends ContactStates {
  final List<Contact> contact ;
  ContactIsLoaded(this.contact);
}

class ContactCanNotLoaded extends ContactStates {}

