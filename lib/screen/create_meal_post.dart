import 'dart:typed_data';

import 'package:fitness_social_app/commons/commons.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/services/drafts.dart';
import 'package:fitness_social_app/services/meal_service.dart';
import 'package:fitness_social_app/utlis/utils.dart';
import 'package:fitness_social_app/widgets/bottom_modal_item_widget.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateMealPost extends ConsumerStatefulWidget {
  const CreateMealPost({Key? key}) : super(key: key);

  @override
  _CreateMealPostState createState() => _CreateMealPostState();
}

class _CreateMealPostState extends ConsumerState<CreateMealPost> {
  Uint8List? image;
  MealDraft? mealDraft;
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController ingredientController = TextEditingController();

  void selectImage(String mode) async {
    try {
      Uint8List? file;
      if (mode == 'Camera') {
        file = await Utils().pickImage(ImageSource.camera);
      } else {
        file = await Utils().pickImage(ImageSource.gallery);
      }

      setState(() {
        mealDraft!.image = file;
      });
    } catch (e) {
      print(e);
    }
  }

  FocusNode focusNode = FocusNode();

  List<String> popularTags = [
    "Protein",
    "Chiken",
    "Vegan",
    "Low Calorie",
    "Low Fat"
  ];

  List<String> commonIngredients = [
    "Beef",
    "Chiken",
    "Pork",
    "Turmeric",
    "Rice",
  ];

  @override
  void initState() {
    super.initState();
    mealDraft = ref.read(mealDraftProvider);
    titleController.text = mealDraft!.mealName;
  }

  @override
  Widget build(BuildContext context) {
    void delete(int index) {
      setState(() {
        mealDraft!.categories.removeAt(index);
      });
    }

    return WillPopScope(
      onWillPop: () async {
        mealDraft!.mealName = titleController.text;
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: const Text('Create a Meal'),
                elevation: 0,
                actions: [
                  GestureDetector(
                    onTap: () async {
                      if (mealDraft!.mealName != "" &&
                          mealDraft!.image != null) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        );
                        MealModel thisMeal = MealModel(
                            mealName: mealDraft!.mealName,
                            description: mealDraft!.description,
                            uid: "",
                            postId: "",
                            ingredients: mealDraft!.ingredients,
                            tags: mealDraft!.categories);

                        try {
                          // await WorkoutPostServices()
                          //     .postTemplate(workoutModel, workoutDraft!.exercises);
                          await MealServices()
                              .postMeal(thisMeal, mealDraft!.image!);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(Commons()
                              .snackBarMessage(e.toString(), Colors.red));
                        }
                        ref.invalidate(mealDraftProvider);
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(Commons()
                              .snackBarMessage("Post Name or Image is missing", Colors.red));
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.upload_rounded),
                    ),
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
                              child: BottomModalItem(
                                  text: "Click a picture",
                                  icon: Icons.photo_outlined),
                            ),
                            const Divider(),
                            GestureDetector(
                              onTap: () => selectImage('Gallery'),
                              child: BottomModalItem(
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
                      child: mealDraft!.image == null
                          ? const Center(
                              child: Icon(size: 48, Icons.add_a_photo_outlined),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                mealDraft!.image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: mealDraft!.categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: PillWidget(
                                    editable: true,
                                    delete: () {
                                      delete(index);
                                    },
                                    name: mealDraft!.categories[index],
                                    active: false),
                              );
                            },
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          focusNode.requestFocus();

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            showDragHandle: true,
                            useSafeArea: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (context) {
                              return SizedBox(
                                height: 450,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                              focusNode: focusNode,
                                              textController:
                                                  categoryController,
                                              hintText: 'add a category'),
                                        ),
                                        FloatingActionButton(
                                          mini: true,
                                          onPressed: () {
                                            setState(() {
                                              mealDraft!.categories
                                                  .add(categoryController.text);
                                              categoryController.text = '';
                                            });
                                          },
                                          child: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Center(
                                      child: Text("Popular Tags: "),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: popularTags.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                mealDraft!.categories
                                                    .add(popularTags[index]);
                                                context.pop();
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title:
                                                      Text(popularTags[index]),
                                                ),
                                                Divider()
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(Icons.add),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    textController: titleController, hintText: "Meal Name"),
                const SizedBox(
                  height: 20,
                ),
                mealDraft!.ingredients.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mealDraft!.ingredients.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(mealDraft!.ingredients[index]),
                                ),
                                Divider()
                              ],
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text("Any ingredients you add will appear here"),
                      )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 60,
          padding: const EdgeInsets.all(8),
          color: Colors.transparent,
          elevation: 0,
          child: GestureDetector(
              onTap: () {
                focusNode.requestFocus();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) {
                    return SizedBox(
                      height: 450,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                    focusNode: focusNode,
                                    textController: ingredientController,
                                    hintText: 'add an ingredient'),
                              ),
                              FloatingActionButton(
                                mini: true,
                                onPressed: () {
                                  setState(() {
                                    mealDraft!.ingredients
                                        .add(ingredientController.text);
                                    ingredientController.text = '';
                                  });
                                },
                                child: Icon(Icons.add),
                              ),
                            ],
                          ),
                          Divider(),
                          Center(
                            child: Text("Popular Ingredients: "),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: commonIngredients.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mealDraft!.ingredients
                                          .add(commonIngredients[index]);
                                      context.pop();
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(commonIngredients[index]),
                                      ),
                                      Divider()
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: const CustomButton(buttonText: 'Add Ingredient')),
        ),
      ),
    );
  }
}
