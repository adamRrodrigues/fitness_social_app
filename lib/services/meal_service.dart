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
          .update({'postId': value.id, 'uId': thisUser!.uid});

      String thumbnail = await StorageServices()
          .postThumbnail('mealPostImages', value.id, image);

      await meals.doc(value.id).update({'imageUrl': thumbnail});
    });
  }
}