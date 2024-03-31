import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/auth/auth_console.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/pages/main_page.dart';
import 'package:fitness_social_app/services/auth_service.dart';
import 'package:fitness_social_app/services/routine_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class AuthState extends ConsumerStatefulWidget {
  const AuthState({Key? key}) : super(key: key);

  @override
  _AuthStateState createState() => _AuthStateState();
}

class _AuthStateState extends ConsumerState<AuthState> {
  @override
  Widget build(BuildContext context) {
    Auth auth = ref.read(authProvider);

    Future createAccount() async {
      await RoutineServices().createRoutine();
      setState(() {
        auth.isRegistering = false;
      });
    }

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!auth.isRegistering) {
              return const MainPage();
            } else {
              createAccount();
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LottieBuilder.network(
                        width: 200,
                        height: 200,
                        "https://lottie.host/3e0b9701-52a6-48d0-9cd5-e39ff87fe8d1/78vBEyMgMI.json"),
                    Text("Creating Your Account Please Wait"),
                  ],
                ),
              );
            }
          } else {
            return const AuthConsole();
          }
        },
      ),
    );
  }
}
