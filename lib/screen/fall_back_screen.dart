import 'package:fitness_social_app/services/fallback_services.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FallBackScreen extends StatefulWidget {
  const FallBackScreen({Key? key}) : super(key: key);

  @override
  State<FallBackScreen> createState() => _FallBackScreenState();
}

class _FallBackScreenState extends State<FallBackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    FallbackService().updatePost();
                  });
                },
                child: CustomButton(buttonText: 'UpdatePosts')),
          )
        ],
      ),
    );
  }
}
