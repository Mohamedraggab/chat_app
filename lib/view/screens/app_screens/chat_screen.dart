import 'package:chat_app/model/user_model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/get_chat_data_controller/get_chat_data_controller.dart';
import '../../../controller/get_chat_data_controller/get_chat_data_state.dart';
import '../../../model/messages_model.dart';

class ChatScreen extends StatelessWidget {
  final UserModel userModel;
  const ChatScreen(this.userModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocProvider(
          create: (context) =>
              GetChatsController()..getMessages(receiverId: userModel.uId),
          child: BlocConsumer<GetChatsController, ChatDataState>(
            listener: (context, state) {},
            builder: (context, state) {
              var textController = TextEditingController();

              return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    leadingWidth: 25,
                    title: ListTile(
                      title: Text(userModel.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          softWrap: true),
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(userModel.image)),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0.0,
                  ),
                  body: ConditionalBuilder(
                    condition: true,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(
                              child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var message = GetChatsController.get(context)
                                  .messages[index];
                              if (message.senderId == userModel.uId) {
                                return buildMessage(message);
                              }
                              return buildMyMessage(message);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 5,
                            ),
                            itemCount:
                                GetChatsController.get(context).messages.length,
                          )),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 55,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30)),
                                    color: Colors.black12,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: TextField(
                                        controller: textController,
                                        decoration: const InputDecoration(
                                            hintText: 'Type Your Message...',
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 55,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                                  color: Colors.grey,
                                ),
                                child: MaterialButton(
                                    onPressed: () {
                                      GetChatsController.get(context)
                                          .sentMessages(
                                        text: textController.text,
                                        dateTime: DateTime.now().toString(),
                                        receiverId: userModel.uId,
                                      );
                                    },
                                    minWidth: 1,
                                    child: const Icon(
                                      Icons.send,
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    fallback: (context) => const Center(
                        child: Text(
                      'There is no messages yet',
                      style: TextStyle(color: Colors.grey),
                    )),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

buildMessage(MessageModel model) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(12),
          topStart: Radius.circular(12),
          topEnd: Radius.circular(12),
        ),
      ),
      child: Text(model.text,
          softWrap: true, style: const TextStyle(fontSize: 15)),
    ),
  );
}

buildMyMessage(MessageModel model) {
  return Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
      decoration: const BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(12),
          topStart: Radius.circular(12),
          topEnd: Radius.circular(12),
        ),
      ),
      child: Text(model.text,
          softWrap: true, style: const TextStyle(fontSize: 15)),
    ),
  );
}
