import 'package:chat_app/controller/auth_controller/login_states.dart';
import 'package:chat_app/view/screens/Authentication/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat_app/view/constants.dart';
import '../../widget/custom_text_form.dart';
import 'package:chat_app/controller/auth_controller/login_controller.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final mailController = TextEditingController();
  final passController = TextEditingController();
  final loginControllerInstance = LoginController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginController(),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: BlocConsumer<LoginController , LoginState>( listener: (context, state) {

        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: ConditionalBuilder(
              condition: state is !Login,
              builder: (context) {
                return SingleChildScrollView(
                    child: Stack(
                      children: [
                        Container(
                          color: HexColor(Constants.authScreenDarkColor),
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.3,
                                width: double.infinity,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 22),
                                  decoration: BoxDecoration(
                                    color: HexColor(Constants.authScreenDarkColor),
                                  ),
                                  /////////////Login Header in dark part/////////////////////////
                                  child: buildLoginHeader(),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.7,
                                width: double.infinity,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(50),
                                        topLeft: Radius.circular(50),
                                      )),
                                  color: HexColor(Constants.authScreenElementColor),
                                  ////////////////form in white space//////////////////
                                  child: buildFormInWhiteSpace(context),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              fallback: (context) => const Center(child: CircularProgressIndicator()),),
          );
        },
        ),
      ),
    );
  }

  Widget buildFormInWhiteSpace(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          customTextForm(
              label: 'Email',
              preIcon: Icons.email_outlined,
              controller: mailController,
              isPassword: false),
          const SizedBox(
            height: 20,
          ),
          customTextForm(
              label: 'Password',
              preIcon: Icons.password,
              controller: passController,
              isPassword: true),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                        minimumSize: const MaterialStatePropertyAll(
                            Size(double.infinity, 48)),
                        backgroundColor: MaterialStatePropertyAll(
                            HexColor(Constants.authScreenDarkColor)),
                      ),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        loginControllerInstance.login(
                          email: mailController.text,
                          password: passController.text,
                          context: context,
                        );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily:
                                GoogleFonts.montserratAlternates().fontFamily),
                      ))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ));
                },
                child: const Text('SignUp'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLoginHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login',
          style: GoogleFonts.montserratAlternates(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Please Sign in to continue',
          style: GoogleFonts.montserratAlternates(
            fontSize: 22,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
