import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/auth_service.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key, required this.changeAuthState}) : super(key: key);
  final Function changeAuthState;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordContoller = TextEditingController();
  Auth? auth;

  @override
  void initState() {
    super.initState();
    auth = ref.read(authProvider);
  }

  @override
  Widget build(BuildContext context) {
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
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    textController: usernameController, hintText: 'username'),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    textController: emailController, hintText: 'email'),
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
                GestureDetector(
                    onTap: () {
                      auth!.isRegistering = true;

                      auth!.signUp(
                        context,
                        emailController.text,
                        usernameController.text,
                        passwordContoller.text,
                      );
                    },
                    child: const CustomButton(buttonText: 'Sign up')),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.changeAuthState();
                      },
                      child: Text(
                        " Sign in",
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
