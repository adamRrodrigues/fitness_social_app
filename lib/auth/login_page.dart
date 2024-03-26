import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/auth_service.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key, required this.changeAuthState}) : super(key: key);
  final Function changeAuthState;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  Auth auth = Auth();
  @override
  void initState() {
    super.initState();
    auth = ref.read(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordContoller = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.file_copy_outlined,
                  size: 128,
                ),
                const SizedBox(
                  height: 70,
                ),
                CustomTextField(
                    textController: emailController,
                    hintText: 'email',
                    maxLength: 100,
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  textController: passwordContoller,
                  hintText: 'password',
                  obscure: true,
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        // Navigator.pushReplacement(context, MaterialPageRoute(
                        //   builder: (context) {
                        //     return MainPage();
                        //   },
                        // ));
                        auth.isRegistering = false;
                        auth.signIn(context, emailController.text,
                            passwordContoller.text);
                      },
                      child: const CustomButton(buttonText: 'Sign In')),
                ),
                const SizedBox(
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
