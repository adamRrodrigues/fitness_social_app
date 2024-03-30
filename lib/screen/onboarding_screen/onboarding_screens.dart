import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/collections/collections.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/pages/main_page.dart';
import 'package:fitness_social_app/services/auth_service.dart';
import 'package:fitness_social_app/services/routine_services.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreens extends ConsumerStatefulWidget {
  const OnboardingScreens({Key? key}) : super(key: key);

  @override
  _OnboardingScreensState createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends ConsumerState<OnboardingScreens> {
  Auth? auth;
  TextEditingController nameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  Future createAccount() async {
    await RoutineServices().createRoutine();

    await Collections.users.doc(user!.uid).update({
      "firstName": nameController.text,
      "lastName": lNameController.text,
    });
    setState(() {
      auth!.isRegistering = false;
    });
  }

  @override
  void initState() {
    super.initState();
    auth = ref.read(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      back: const Icon(Icons.arrow_back),
      showBackButton: true,
      scrollPhysics: NeverScrollableScrollPhysics(),
      next: const Icon(Icons.arrow_forward),
      pages: [
        PageViewModel(
          decoration: PageDecoration(bodyAlignment: Alignment.center),
          title: "Welcome to Fitnus",
          body:
              "Join A Welcoming Community That Loves Fitness Just As Much As You <3",
          // image: Image.asset("assets/slide_1.png"),
        ),
        PageViewModel(
            decoration: PageDecoration(
              bodyAlignment: Alignment.center,
            ),
            title: "Let's Get Your Account Set Up!!",
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextField(
                    maxLength: 20,
                    textController: nameController,
                    hintText: "first name"),
                CustomTextField(
                    maxLength: 20,
                    textController: lNameController,
                    hintText: "last name"),
                Text("You Can Always Change This Infromation Later")
              ],
            )
            // image: Image.asset("assets/slide_2.png"),
            ),
        PageViewModel(
          decoration: PageDecoration(bodyAlignment: Alignment.center),
          title: "Alright You're All Set Let's Get Fit!",
          body: "",
          // image: Image.asset("assets/slide_3.png"),
        ),
      ],
      done: Text("Get Started"),
      hideBottomOnKeyboard: true,
      onDone: () async {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        await createAccount();
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return MainPage();
          },
        ));
        setState(() {
          auth!.isRegistering = false;
        });
      },
    );
  }
}
