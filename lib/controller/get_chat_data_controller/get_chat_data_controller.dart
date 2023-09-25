import 'package:chat_app/controller/get_chat_data_controller/get_chat_data_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/messages_model.dart';
import '../../model/user_model.dart';

class GetChatsController extends Cubit<ChatDataState> {
  GetChatsController() : super(ChatDataInitState());

  static GetChatsController get(context) => BlocProvider.of(context);

  /////////////////////////////////GetChats/////////////////////////////////



  List<String> lastMessage = [];
  List<UserModel> users = [];
  UserModel? currentUser;

  getAllUsersId() async {
    users = [];
    emit(GetAllUsersIdState());
    var v = FirebaseFirestore.instance.collection('users');
    await v.get().then((value) {
      for (var element in value.docs) {
        if (FirebaseAuth.instance.currentUser!.uid != element.data()['uid'].toString()) {
          users.add(UserModel.fromJson(element.data()));
          emit(GetAllUsersIdSuccessState());
        }
        else{
          currentUser = UserModel.fromJson(element.data());
          emit(GetAllUsersIdSuccessState());
        }
      }
    }).catchError((error) {
      emit(GetAllUsersIdErrorState());
    });
  }


  sentMessages({
    required String text,
    required String dateTime,
    required String receiverId,
  }) {
    MessageModel model = MessageModel(
        text: text,
        dateTime: dateTime,
        receiverId: receiverId,
        senderId:FirebaseAuth.instance.currentUser!.uid);
    FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
      //getMessages();
    })
        .catchError((error) {
      emit(SendMessageErrorState());
    });

    FirebaseFirestore
        .instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    })
        .catchError((error) {
      emit(SendMessageErrorState());
    });
  }


  List<MessageModel> messages = [];

  getMessages({required String receiverId}) {
    FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection("messages")
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          messages = [];
          for (var element in event.docs) {
            messages.add(MessageModel.fromJson(element.data()));
          }
          emit(GetMessageSuccessState());
    });
  }
}
