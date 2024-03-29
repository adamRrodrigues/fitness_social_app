import 'package:fitness_social_app/collections/collections.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    TextEditingController fNameController =
        TextEditingController(text: user.firstName);
    TextEditingController lNameController =
        TextEditingController(text: user.lastName);
    TextEditingController uNameController =
        TextEditingController(text: user.username);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
              await Collections.users.doc(user.uid).update({
                "firstName": fNameController.text,
                "lastName": lNameController.text,
                "username": uNameController.text.replaceAll(" ", "").toLowerCase()
              });
              if (context.mounted) {
                context.pop();
                context.pop();
              }
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.edit_rounded),
            ),
          )
        ],
      ),
      body: ListView(
          padding: EdgeInsets.all(8),
          physics: BouncingScrollPhysics(),
          children: [
            CustomTextField(
                textController: fNameController, hintText: "First Name"),
            CustomTextField(
                textController: lNameController, hintText: "Last Name"),
            CustomTextField(
                textController: uNameController, hintText: "username")
          ]),
    );
  }
}
