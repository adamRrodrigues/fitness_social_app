import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/auth/auth_console.dart';
import 'package:fitness_social_app/pages/main_page.dart';
import 'package:fitness_social_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthState extends StatelessWidget {
  const AuthState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainPage();
          } else {
            return const AuthConsole();
          }
        },
      ),
    );
  }
}
