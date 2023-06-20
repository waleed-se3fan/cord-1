import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'app/audio/cubit/audio_cubit.dart';
import 'app/chat/cubit/chat_cubit.dart';
import 'app/chat_details/cubit/chat_details_cubit.dart';
import 'app/contacts/cubit/contact_cubit.dart';
import 'core/utils/bloc_observer.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ChatCubit>(create: (BuildContext context)=> ChatCubit()),
      BlocProvider<ContactCubit>(create: (BuildContext context)=> ContactCubit()),
      BlocProvider<ChatDetailsCubit>(create: (BuildContext context)=> ChatDetailsCubit()),
      BlocProvider<AudioCubit>(create: (BuildContext context)=> AudioCubit()),
    ],
    child: const CordApp(),
  ));
}
