import 'package:fitness_social_app/services/auth_service.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.changeAuthState}) : super(key: key);
  final Function changeAuthState;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordContoller = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.file_copy_outlined,
                  size: 128,
                ),
                SizedBox(
                  height: 70,
                ),
                CustomTextField(
                    textController: emailController, hintText: 'email'),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  textController: passwordContoller,
                  hintText: 'password',
                  obscure: true,
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                    onTap: () {
                      // Navigator.pushReplacement(context, MaterialPageRoute(
                      //   builder: (context) {
                      //     return MainPage();
                      //   },
                      // ));
                      auth.signIn(context, emailController.text,
                          passwordContoller.text);
                    },
                    child: CustomButton(buttonText: 'Sign In')),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.changeAuthState();
                      },
                      child: Text(
                        " Sign Up",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Colors.cyan,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
