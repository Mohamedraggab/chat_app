import 'package:chat_app/controller/auth_controller/login_states.dart';
import 'package:chat_app/view/constants.dart';
import 'package:chat_app/view/screens/app_screens/layout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginController extends Cubit<LoginState> {
  LoginController() : super(LoginInitState());

  static LoginController get(context) => BlocProvider.of(context);

  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    emit(Login());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Constants.id = value.user!.uid.toString();
      debugPrint('LogIn  Successfully');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LayoutScreen(),
          ),
          (route) => false);
      emit(LoginSuccessState());
    }).catchError((error) {
      emit(LoginErrorState());
      debugPrint(error.toString());
    });
  }

}
