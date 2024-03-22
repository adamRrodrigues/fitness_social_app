import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/services/storage_services.dart';

class MealServices {
  final thisUser = FirebaseAuth.instance.currentUser;
  CollectionReference meals =
      FirebaseFirestore.instance.collection('meals_demo');
  Future postMeal(MealModel meal, Uint8List image) async {
    await meals.add(meal.toMap()).then((value) async {
      await meals
          .doc(value.id)
          .update({'postId': value.id, 'uid': thisUser!.uid});

      String thumbnail = await StorageServices()
          .postThumbnail('mealPostImages', value.id, image);

      await meals.doc(value.id).update({'image': thumbnail});
    });
  }

  Future deleteMeal(String mealId) async {
    await StorageServices().deleteImages('mealPostImages', mealId);
    await FirebaseFirestore.instance
        .collection('meals_demo')
        .doc(mealId)
        .delete();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(thisUser!.uid)
        .update({
      'posts': FieldValue.arrayRemove([mealId])
    });
  }

  MealModel getMealFromDoc(QueryDocumentSnapshot<Object?> data) {
    final meal = MealModel(
        mealName: data['mealName'],
        description: data['description'],
        uid: data['uid'],
        postId: data['postId'],
        image: data['image'],
        ingredients: List.from(data['ingredients']),
        tags: List.from(data['tags']));
    return meal;
  }
}
