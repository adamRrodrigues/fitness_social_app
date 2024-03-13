import 'dart:typed_data';

import 'package:fitness_social_app/utlis/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateMealPost extends StatefulWidget {
  const CreateMealPost({Key? key}) : super(key: key);

  @override
  _CreateMealPostState createState() => _CreateMealPostState();
}

class _CreateMealPostState extends State<CreateMealPost> {
  Uint8List? image;

  void selectImage(String mode) async {
    try {
      Uint8List? file;
      if (mode == 'Camera') {
        file = await Utils().pickImage(ImageSource.camera);
      } else {
        file = await Utils().pickImage(ImageSource.gallery);
      }

      setState(() {
        image = file;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: const Text('Create a Meal'),
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.upload_rounded),
                )
              ],
              backgroundColor: Theme.of(context).colorScheme.background,
              // snap: true,
              floating: true,
            )
          ],
          body: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    useSafeArea: true,
                    builder: (context) {
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          GestureDetector(
                            onTap: () => selectImage('Camera'),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child:
                                        ListTile(title: Text('Take A Picture')),
                                  ),
                                  Icon(Icons.camera_alt_outlined)
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () => selectImage('Gallery'),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: ListTile(
                                          title: Text('Choose From Gallery'))),
                                  Icon(Icons.image_outlined)
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary),
                        borderRadius: BorderRadius.circular(10)),
                    child: image == null
                        ? const Center(
                            child: Icon(size: 48, Icons.add_a_photo_outlined),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
