import 'package:chat_app/controller/profile_controller/profile_states.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/view/screens/app_screens/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/profile_controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.userdata,
  });
  final UserModel? userdata;

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController(text: userdata!.username);
    var phoneController = TextEditingController(text: userdata!.phone);
    return BlocProvider(
      create: (context) => ProfileController(),
      child: BlocConsumer<ProfileController, ProfileStates>(
        listener: (context, state) {
          if (state is SuccessUpdateProfile) {
            build(context);

          }
        },
        builder: (context, state) {
          var cubit = ProfileController.get(context);
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: profileScreenAppBar(context),
              backgroundColor: Colors.white,
              body: Builder(
                builder: (context) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (state is InitUpdateProfile ||
                            state is InitUploadProfileImage)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: LinearProgressIndicator(),
                          )
                        else
                          const SizedBox(),
                        profilePicWidgetStack(cubit),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                            minLines: 1,
                            decoration:
                                const InputDecoration(border: OutlineInputBorder()),
                            controller: nameController),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            minLines: 1,
                            decoration:
                                const InputDecoration(border: OutlineInputBorder()),
                            controller: phoneController),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            minLines: 1,
                            decoration: const InputDecoration(
                                enabled: false, border: OutlineInputBorder()),
                            controller: TextEditingController(
                              text: userdata!.email,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        updateButton(cubit, nameController, phoneController),
                      ],
                    ),
                  );
                }
              ),
            ),
          );
        },
      ),
    );
  }

  MaterialButton updateButton(ProfileController cubit, TextEditingController nameController, TextEditingController phoneController) {
    return MaterialButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (cubit.profileImage != null) {
                      cubit.uploadProfileImage(
                          name: nameController.text,
                          phone: phoneController.text);
                    }
                    if (cubit.profileImage == null) {
                      cubit.updateProfile(
                          name: nameController.text,
                          phone: phoneController.text,
                          image: userdata!.image);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Update',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                );
  }

  Stack profilePicWidgetStack(ProfileController cubit) {
    return Stack(
                  children: [
                    Positioned(
                      child: CircleAvatar(
                        radius: 100,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            image: DecorationImage(
                              image: cubit.profileImage == null
                                  ? NetworkImage(userdata!.image.toString())
                                  : FileImage(cubit.profileImage)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 14,
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            cubit.getProfileImage();
                          },
                          icon: const Icon(Icons.camera),
                          iconSize: 32,
                          color: Colors.lightBlue,
                      ),
                    ),
                  ],
                );
  }

  AppBar profileScreenAppBar(BuildContext context) {
    return AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LayoutScreen(),
                    ),
                    (route) => true);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          );
  }
}
