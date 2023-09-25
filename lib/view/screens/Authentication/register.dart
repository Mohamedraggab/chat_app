import 'package:chat_app/view/screens/Authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat_app/view/constants.dart';
import '../../widget/custom_text_form.dart';
import 'package:chat_app/controller/auth_controller/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final mailController = TextEditingController();
  final passController = TextEditingController();
  final userNameController = TextEditingController();
  final phoneController = TextEditingController();
  final registerController = Register();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
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
                        child: buildCreateAccountLabel(),
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildForm(context),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column buildCreateAccountLabel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Account',
          style: GoogleFonts.montserratAlternates(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Column buildForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        customTextForm(
            label: 'User Name',
            preIcon: Icons.person,
            controller: userNameController,
            isPassword: false),
        const SizedBox(
          height: 20,
        ),
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
        customTextForm(
            label: 'Phone Number',
            preIcon: Icons.phone,
            controller: phoneController,
            isPassword: false),
        const SizedBox(
          height: 20,
        ),
        buildRegisterButton(),
        buildNavToLogin(context),
      ],
    );
  }

  Row buildRegisterButton() {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  minimumSize:
                      const MaterialStatePropertyAll(Size(double.infinity, 40)),
                  backgroundColor: MaterialStatePropertyAll(HexColor('0B666A')),
                ),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  registerController.register(
                      username: userNameController.text,
                      email: mailController.text,
                      password: passController.text,
                      phone: phoneController.text);
                },
                child: const Text('Register'))),
      ],
    );
  }

  Row buildNavToLogin(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account'),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
