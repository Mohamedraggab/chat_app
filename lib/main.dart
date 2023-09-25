import 'package:chat_app/controller/get_chat_data_controller/get_chat_data_controller.dart';
import 'package:chat_app/view/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/get_chat_data_controller/get_chat_data_state.dart';
import 'controller/observer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = const AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => GetChatsController(),
      child: BlocConsumer<GetChatsController , ChatDataState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            theme: ThemeData(
              fontFamily: GoogleFonts.aleo().fontFamily
            ),
            //themeMode: GetChatsController.get(context).isDark ? ThemeMode.dark : ThemeMode.light ,
            home: StartScreen(),
          );
        },
      )
    );
  }
}
