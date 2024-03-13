import 'package:flutter/material.dart';

class CreateMealPost extends StatefulWidget {
  const CreateMealPost({Key? key}) : super(key: key);

  @override
  _CreateMealPostState createState() => _CreateMealPostState();
}

class _CreateMealPostState extends State<CreateMealPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Meal'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.upload_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(),
      ),
    );
  }
}
