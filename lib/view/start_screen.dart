import 'package:chat_app/view/screens/Authentication/login.dart';
import 'package:chat_app/view/screens/app_screens/layout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirebaseAuth.instance.currentUser?.uid == null
          ? LoginScreen()
          : const LayoutScreen(),
    );
  }
}
