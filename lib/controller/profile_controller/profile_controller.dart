import 'package:chat_app/controller/profile_controller/profile_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_firestore;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../model/user_model.dart';

class ProfileController extends Cubit<ProfileStates> {
  ProfileController() : super(InitProfileState());

  static ProfileController get(context) => BlocProvider.of(context);

  dynamic profileImage;

  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      emit(SuccessGetProfileImage());
    } else {
      emit(ErrorGetProfileImage());
      //print('No Image Selected');
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
  }) {
    emit(InitUploadProfileImage());
    firebase_firestore.FirebaseStorage.instance
        .ref()
        .child('usersProfiles/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateProfile(name: name, phone: phone, image: value);
        emit(SuccessUploadProfileImage());
      }).catchError((error) {});
    }).catchError((error) {
      emit(ErrorUploadProfileImage());
    });
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String image,
  }) async {
    emit(InitUpdateProfile());
    UserModel model = UserModel(
      username: name,
      phone: phone,
      email: FirebaseAuth.instance.currentUser!.email.toString(),
      uId: (FirebaseAuth.instance.currentUser)!.uid,
      image: image,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser)!.uid)
        .update(model.toMap())
        .then((value) {
      profileImage = null;
      emit(SuccessUpdateProfile());
    }).catchError((error) {
      emit(ErrorUpdateProfile());
    });
  }
}
