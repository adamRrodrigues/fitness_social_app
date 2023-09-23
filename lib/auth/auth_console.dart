import 'package:fitness_social_app/auth/login_page.dart';
import 'package:fitness_social_app/auth/signup_page.dart';
import 'package:flutter/material.dart';

class AuthConsole extends StatefulWidget {
  const AuthConsole({Key? key}) : super(key: key);

  @override
  _AuthConsoleState createState() => _AuthConsoleState();
}

class _AuthConsoleState extends State<AuthConsole> {
  bool showLogin = true;

  void changeAuthState() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLogin
          ? LoginPage(
              changeAuthState: changeAuthState,
            )
          : SignupPage(
              changeAuthState: changeAuthState,
            ),
    );
  }
}
