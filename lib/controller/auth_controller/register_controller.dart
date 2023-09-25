import 'package:chat_app/view/screens/Authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:get/get.dart';

class Register {
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        createUsers(
            email: email,
            username: username,
            phone: phone,
            uId: value.user!.uid).catchError((error){
              debugPrint(error.toString());
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> createUsers({
    required String email,
    required String username,
    required String phone,
    required String uId,
  }) async {
    UserModel model = UserModel(
        username: username, email: email, phone: phone, uId: uId, image: 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=826&t=st=1689987926~exp=1689988526~hmac=3e27ec7fc5a76709c64f983fb0e4d0a36303861129463672a635117541f207ac');

    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(model.toMap()).then((value){
            debugPrint('user created');
            Get.to(()=> LoginScreen());
      }).catchError((error){
        debugPrint(error.toString());

      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
