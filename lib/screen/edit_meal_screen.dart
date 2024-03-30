import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/commons/commons.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/services/drafts.dart';
import 'package:fitness_social_app/services/meal_service.dart';
import 'package:fitness_social_app/utlis/utils.dart';
import 'package:fitness_social_app/widgets/bottom_modal_item_widget.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EditMealPost extends ConsumerStatefulWidget {
  const EditMealPost({Key? key, required this.meal}) : super(key: key);
  final MealModel meal;
  @override
  _EditMealPostState createState() => _EditMealPostState();
}

class _EditMealPostState extends ConsumerState<EditMealPost>
    with SingleTickerProviderStateMixin {
  MealDraft? mealDraft;
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController ingredientController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController servingsController = TextEditingController();
  late TabController tabController;
  User? user = FirebaseAuth.instance.currentUser;

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
    "2/3 Beef",
    "1/2 Chiken",
    "3/4 Pork",
    "1 pinch Turmeric",
    "1 cup Rice",
  ];

  List<String> commonSteps = [
    "Wash rice",
    "Chop onions into thin slices ",
    "Tenderize chicken thoroughly",
    "Tenderize beef thoroughly",
    "fry for 6 minutes each side",
  ];

  @override
  void initState() {
    super.initState();
    mealDraft = ref.read(mealDraftProvider);
    titleController.text = widget.meal.mealName;
    mealDraft!.categories = widget.meal.tags;
    caloriesController.text = widget.meal.calories.toString();
    servingsController.text = widget.meal.servings.toString();
    mealDraft!.ingredients = widget.meal.ingredients;
    mealDraft!.steps = widget.meal.steps;

    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
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
        ref.invalidate(mealDraftProvider);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: const Text('Edit a Meal'),
                elevation: 0,
                actions: [
                  GestureDetector(
                    onTap: () async {
                      if (titleController.text != "" &&
                          caloriesController.text != "" &&
                          servingsController.text != "") {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        );
                        MealModel? mealModel;
                        if (widget.meal.uid == user!.uid) {
                          mealModel = MealModel(
                              mealName: titleController.text,
                              description: mealDraft!.description,
                              calories: double.parse(caloriesController.text),
                              uid: widget.meal.uid,
                              postId: widget.meal.postId,
                              servings: int.parse(servingsController.text),
                              image: mealDraft!.image != null
                                  ? ""
                                  : widget.meal.image,
                              likes: widget.meal.likes,
                              steps: mealDraft!.steps,
                              ingredients: mealDraft!.ingredients,
                              tags: mealDraft!.categories);

                          try {
                            await MealServices().editMeal(mealModel);
                            if (mealDraft!.image != null) {
                              await MealServices().newImage(
                                  mealDraft!.image!, widget.meal.postId);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(Commons()
                                .snackBarMessage(
                                    "Meal Created Successfully", Colors.green));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(Commons()
                                .snackBarMessage(e.toString(), Colors.red));
                          }
                        } else {
                          mealModel = MealModel(
                              mealName: titleController.text,
                              description: mealDraft!.description,
                              calories: double.parse(caloriesController.text),
                              uid: "",
                              postId: "",
                              servings: int.parse(servingsController.text),
                              image: mealDraft!.image != null
                                  ? ""
                                  : widget.meal.image,
                              likes: List.empty(),
                              steps: mealDraft!.steps,
                              ingredients: mealDraft!.ingredients,
                              tags: mealDraft!.categories);
                          try {
                            String fs =
                                await MealServices().templateToMeal(mealModel, );
                            if (mealDraft!.image != null) {
                              await MealServices()
                                  .newImage(mealDraft!.image!, fs);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(Commons()
                                .snackBarMessage(
                                    "Meal Created Successfully", Colors.green));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(Commons()
                                .snackBarMessage(e.toString(), Colors.red));
                          }
                        }

                        ref.invalidate(mealDraftProvider);
                        if (context.mounted) {
                          context.pop();
                          // Navigator.pop(context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(Commons()
                            .snackBarMessage(
                                "Meal Name, image, calories and servings should all be filled",
                                Colors.red));
                      }
                      if (context.mounted) {
                        context.pop();
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
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
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
                        child: mealDraft!.image == null
                            ? Center(child: ImageWidget(url: widget.meal.image))
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
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
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
                                                maxLength: 10,
                                                hintText: 'add a category'),
                                          ),
                                          FloatingActionButton(
                                            mini: true,
                                            onPressed: () {
                                              setState(() {
                                                mealDraft!.categories.add(
                                                    categoryController.text);
                                                categoryController.text = '';
                                              });
                                            },
                                            child: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      const Center(
                                        child: Text("Popular Tags: "),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: popularTags.length,
                                          physics:
                                              const BouncingScrollPhysics(),
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
                                                    title: Text(
                                                        popularTags[index]),
                                                  ),
                                                  const Divider()
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
                          child: const Icon(Icons.add),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      maxLength: 20,
                      textController: titleController,
                      hintText: "Meal Name"),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                            textController: caloriesController,
                            textInputType: TextInputType.number,
                            maxLength: 5,
                            hintText: "Calories"),
                      ),
                      Expanded(
                        child: CustomTextField(
                            textController: servingsController,
                            textInputType: TextInputType.number,
                            maxLength: 2,
                            hintText: "Servings"),
                      ),
                    ],
                  ),
                  TabBar(
                    onTap: (value) {
                      setState(() {});
                    },
                    controller: tabController,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    tabs: [
                      Tab(
                          icon: Icon(
                        Icons.food_bank_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                      Tab(
                          icon: Icon(
                        Icons.list_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        mealDraft!.ingredients.isNotEmpty
                            ? ingredientsMethod()
                            : const Center(
                                child: Text(
                                    "Any ingredients you add will appear here"),
                              ),
                        mealDraft!.steps.isNotEmpty
                            ? stepsMethod()
                            : const Center(
                                child: Text(
                                  "Any steps you add will appear here",
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
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
                                    hintText: tabController.index == 0
                                        ? '1/2 chicken, 3/4 cup water'
                                        : "Wash rice"),
                              ),
                              FloatingActionButton(
                                mini: true,
                                onPressed: () {
                                  if (tabController.index == 0) {
                                    setState(() {
                                      mealDraft!.ingredients
                                          .add(ingredientController.text);
                                      ingredientController.text = '';
                                    });
                                  } else {
                                    setState(() {
                                      mealDraft!.steps
                                          .add(ingredientController.text);
                                      ingredientController.text = '';
                                    });
                                  }
                                  context.pop();
                                },
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          const Divider(),
                          const Center(
                            child: Text("Popular Ingredients: "),
                          ),
                          Expanded(
                            child: Builder(builder: (context) {
                              if (tabController.index == 0) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
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
                                            title:
                                                Text(commonIngredients[index]),
                                          ),
                                          const Divider()
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: commonSteps.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          mealDraft!.steps
                                              .add(commonSteps[index]);
                                          context.pop();
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(commonSteps[index]),
                                          ),
                                          const Divider()
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            }),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: CustomButton(
                  buttonText: tabController.index == 0
                      ? 'Add Ingredient'
                      : "Add Step")),
        ),
      ),
    );
  }

  ReorderableListView stepsMethod() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      onReorder: (oldIndex, newIndex) {
        String ingredient = mealDraft!.steps.removeAt(oldIndex);
        mealDraft!.steps
            .insert(newIndex > oldIndex ? newIndex -= 1 : newIndex, ingredient);
      },
      physics: const BouncingScrollPhysics(),
      itemCount: mealDraft!.steps.length,
      itemBuilder: (context, index) {
        return Slidable(
          startActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              autoClose: true,
              borderRadius: BorderRadius.circular(10),
              flex: 1,
              onPressed: (context) {
                setState(() {
                  mealDraft!.steps.add(mealDraft!.steps[index]);
                });
              },
              backgroundColor: Colors.greenAccent,
              foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              icon: Icons.replay_rounded,
              label: 'Duplicate',
            )
          ]),
          endActionPane: ActionPane(
              extentRatio: 0.3,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  autoClose: true,
                  flex: 1,
                  onPressed: (context) {
                    setState(() {
                      mealDraft!.steps.removeAt(index);
                    });
                  },
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                  icon: Icons.delete,
                  label: 'Remove',
                ),
              ]),
          key: ValueKey(index),
          child: GestureDetector(
            onTap: () {
              ingredientController.text = mealDraft!.steps[index];
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
                                  hintText: tabController.index == 0
                                      ? '1/2 chicken, 3/4 cup water'
                                      : "Wash rice"),
                            ),
                            FloatingActionButton(
                              mini: true,
                              onPressed: () {
                                setState(() {
                                  mealDraft!.steps[index] =
                                      ingredientController.text;
                                });
                                context.pop();
                              },
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: ListTile(
              title: Text(mealDraft!.steps[index]),
              leading: const Icon(Icons.menu),
            ),
          ),
        );
      },
    );
  }

  ReorderableListView ingredientsMethod() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      onReorder: (oldIndex, newIndex) {
        String ingredient = mealDraft!.ingredients.removeAt(oldIndex);
        mealDraft!.ingredients
            .insert(newIndex > oldIndex ? newIndex -= 1 : newIndex, ingredient);
      },
      physics: const BouncingScrollPhysics(),
      itemCount: mealDraft!.ingredients.length,
      itemBuilder: (context, index) {
        return Slidable(
          startActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              autoClose: true,
              borderRadius: BorderRadius.circular(10),
              flex: 1,
              onPressed: (context) {
                setState(() {
                  mealDraft!.ingredients.add(mealDraft!.ingredients[index]);
                });
              },
              backgroundColor: Colors.greenAccent,
              foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              icon: Icons.replay_rounded,
              label: 'Duplicate',
            )
          ]),
          endActionPane: ActionPane(
              extentRatio: 0.3,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  autoClose: true,
                  flex: 1,
                  onPressed: (context) {
                    setState(() {
                      mealDraft!.ingredients.removeAt(index);
                    });
                  },
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                  icon: Icons.delete,
                  label: 'Remove',
                ),
              ]),
          key: ValueKey(index),
          child: GestureDetector(
            onTap: () {
              ingredientController.text = mealDraft!.ingredients[index];
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
                                  hintText: tabController.index == 0
                                      ? '1/2 chicken, 3/4 cup water'
                                      : "Wash rice"),
                            ),
                            FloatingActionButton(
                              mini: true,
                              onPressed: () {
                                setState(() {
                                  mealDraft!.ingredients[index] =
                                      ingredientController.text;
                                });
                                context.pop();
                              },
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: ListTile(
              title: Text(mealDraft!.ingredients[index]),
              leading: const Icon(Icons.menu),
            ),
          ),
        );
      },
    );
  }
}
