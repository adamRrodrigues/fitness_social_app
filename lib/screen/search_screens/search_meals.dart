import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/services/meal_service.dart';
import 'package:fitness_social_app/widgets/meal_widgets/meal_widget.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchMeals extends ConsumerWidget {
  const SearchMeals({Key? key, this.selection = false, this.day = 0})
      : super(key: key);
  final bool selection;
  final int day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CollectionReference meals =
        FirebaseFirestore.instance.collection("meals_demo");
    TextEditingController searchController = TextEditingController();
    ValueNotifier<String> searchTerm = ValueNotifier("");
    changeTerm(String hello) {
      searchTerm.value = searchController.text;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: CustomTextField(
                  onChange: changeTerm,
                  textController: searchController,
                  hintText: "search meals"),
            ),
            ValueListenableBuilder(
                valueListenable: searchTerm,
                builder: (context, st, child) {
                  return StreamBuilder(
                    stream: meals
                        .where("mealName", isGreaterThanOrEqualTo: st.trim())
                        .where("mealName",
                            isLessThanOrEqualTo: "${st.trim()}\uf7ff")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.active) {
                        final data = snapshot.data!.docs.toList();
                        if (data.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final meal =
                                  MealServices().getMealFromDoc(data[index]);
                              return MealWidget(
                                meal: meal,
                                selection: selection,
                                day: day,
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text(
                                "Sorry Couldn't Find What You Were Looking For"),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
