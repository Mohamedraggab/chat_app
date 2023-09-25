import 'dart:math';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../controller/get_chat_data_controller/get_chat_data_controller.dart';
import '../../../controller/get_chat_data_controller/get_chat_data_state.dart';
import '../../../model/user_model.dart';
import '../../constants.dart';
import '../Authentication/login.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final sKey = GlobalKey<ScaffoldState>();
    return BlocProvider(
      create: (context) => GetChatsController()..getAllUsersId(),
      child: BlocConsumer<GetChatsController, ChatDataState>(
        listener: (context, state) {},
        builder: (context, state) {
          List<UserModel> model = GetChatsController.get(context).users;
          UserModel? currentUserModel =
              GetChatsController.get(context).currentUser;
          return Scaffold(
            drawer: EndDrawer(
              currentUserModel: currentUserModel,
            ),
            key: sKey,
            extendBody: true,
            body: Builder(
              builder: (context) => Stack(
                children: [
                  Positioned(
                    child: Container(
                      color: HexColor('131c2e'),
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 45, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Messages',
                                style: TextStyle(
                                  color: HexColor('d4d9dd'),
                                  fontSize: 30,
                                  fontFamily: AutofillHints.language,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 70,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStatePropertyAll(HexColor('131c2e')),
                                    backgroundColor: MaterialStatePropertyAll(HexColor('131c2e')),
                                  ),
                                  onPressed: () {
                                    sKey.currentState!.openDrawer();
                                  },
                                  child: SvgPicture.asset('assets/svg/menu.svg' ,
                                    width: 30 ,
                                    height: 30,
                                    colorFilter: ColorFilter.mode(HexColor('d4d9dd'), BlendMode.srcIn),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      height: size.height * 0.88,
                      width: size.width,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        )),
                        child: HomeBody(size: size, model: model),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.size,
    required this.model,
  });

  final Size size;
  final List<UserModel> model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.66,
          child: ConditionalBuilder(
            condition: model.isNotEmpty,
            builder: (context) {
              return ListView.builder(
                itemBuilder: (context, index) =>
                    customVIcons(model[index], context),
                itemCount: model.length,
                physics: const BouncingScrollPhysics(),
              );
            },
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }
}

class EndDrawer extends StatefulWidget {
  const EndDrawer({
    super.key,
    required this.currentUserModel,
  });

  final UserModel? currentUserModel;

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> with SingleTickerProviderStateMixin {

  late AnimationController _controller ;
  late Animation _animation ;
  late Animation _transAnimation ;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(vsync: this ,
        duration: const Duration(milliseconds: 500) );
    var curve = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _animation = Tween(begin:1.0 , end: 0.0).animate(curve);
    _transAnimation =
        Tween(begin: const Offset(100.0, 0.0), end: const Offset(0.0, 0.0))
            .animate(_controller);
    _controller.forward();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: HexColor('131c2e'),
      width: MediaQuery.of(context).size.width * 0.62,
      elevation: 0.0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50,),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(widget.currentUserModel!.image),
                      radius: 25,
                    ),
                    title: Transform.rotate(
                      angle: pi *  _animation.value,
                      child: Text(
                        widget.currentUserModel!.username,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: HexColor('d4d9dd'),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    subtitle: Text(
                      widget.currentUserModel!.phone,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const Padding(
                    padding:
                    EdgeInsets.only(left: 12.0, right: 22, top: 15, bottom: 15),
                    child: Divider(
                      height: 1,
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  const SizedBox(height: 30,),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userdata: widget.currentUserModel),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            child: Transform.scale(
                              scale: _controller.value ,
                              child: SvgPicture.asset('assets/svg/profile.svg' ,
                                width: 30 ,
                                height: 30,
                                colorFilter: ColorFilter.mode(HexColor('d4d9dd'), BlendMode.srcIn),
                                fit: BoxFit.fill,
                              ),
                            ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Transform.translate(
                          offset: _transAnimation.value,
                          transformHitTests: true,
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: HexColor('d4d9dd'),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                                (route) => false);
                        Constants.id = null;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                            child: Transform.scale(
                              scale: _controller.value ,
                              child: SvgPicture.asset('assets/svg/sign-out.svg' ,
                                width: 30 ,
                                height: 30,
                                colorFilter: ColorFilter.mode(HexColor('d4d9dd'), BlendMode.srcIn),
                                fit: BoxFit.fill,
                              ),
                            ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Transform.translate(
                          offset: _transAnimation.value,
                          transformHitTests: true,
                          child: Text(
                            'SignOut',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: HexColor('d4d9dd'),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

customVIcons(UserModel model, context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8, right: 10, left: 10),
    child: InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(model),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 33,
            backgroundImage: NetworkImage(model.image.toString()),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  model.username.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: HexColor('000000'),
                      overflow: TextOverflow.ellipsis),
                ),
                Text(
                  model.email,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black54,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
