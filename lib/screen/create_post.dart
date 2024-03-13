import 'dart:typed_data';

import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/auth_service.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/utlis/utils.dart';
import 'package:fitness_social_app/widgets/bottom_modal_item_widget.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modals/modals.dart';

class CreatePost extends ConsumerStatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost> {
  TextEditingController postNameController = TextEditingController();

  Uint8List? image;

  Utils? imagePicker;

  void selectImage(String mode) async {
    try {
      Uint8List? file;
      if (mode == 'Camera') {
        file = await imagePicker!.pickImage(ImageSource.camera);
      } else {
        file = await imagePicker!.pickImage(ImageSource.gallery);
      }

      setState(() {
        image = file;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    imagePicker = ref.read(utilProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title: Text(
                      'Create a Post',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
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
                              child: const BottomModalItem(
                                  text: "Click a picture",
                                  icon: Icons.photo_outlined),
                            ),
                            const Divider(),
                            GestureDetector(
                              onTap: () => selectImage('Gallery'),
                              child: const BottomModalItem(
                                  text: "Choose from gallery",
                                  icon: Icons.camera_alt_outlined),
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
                CustomTextField(
                    textController: postNameController,
                    hintText: 'Give Your Post A Title'),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () async {
                        if (postNameController.text != '' && image != null) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          );
                          try {
                            await GenericPostServices()
                                .publishPost(postNameController.text, image!);
                          } catch (e) {
                            const AlertDialog(
                              title: Text('crashed for some reason'),
                            );
                          }
                          Navigator.pop(context);
                          postNameController.text = '';
                          image = null;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            Auth().snackBarMessage(
                                'Please add an image and a title', Colors.red),
                          );
                        }
                      },
                      child: const CustomButton(buttonText: 'Post')),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )),
      ),
    );
  }
}
