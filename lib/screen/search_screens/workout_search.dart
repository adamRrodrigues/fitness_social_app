import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutSearch extends ConsumerWidget {
  const WorkoutSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CollectionReference workouts =
        FirebaseFirestore.instance.collection("workout_templates_demo");
    TextEditingController searchController = TextEditingController();
    ValueNotifier<String> searchTerm = ValueNotifier("");
    User? user = ref.read(userProvider);
    changeTerm(String hello) {
      searchTerm.value = searchController.text;
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: CustomTextField(
                  onChange: changeTerm,
                  textController: searchController,
                  hintText: "search Wokrouts"),
            ),
            ValueListenableBuilder(
                valueListenable: searchTerm,
                builder: (context, st, child) {
                  return StreamBuilder(
                    stream:workouts
                        .where("workoutName", isGreaterThanOrEqualTo: st.trim())
                        .where("workoutName",
                            isLessThanOrEqualTo: "${st.trim()}\uf7ff")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.active) {
                        final data = snapshot.data!.docs.toList();
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final workout =
                                WorkoutPostServices().mapDocPost(data[index]);
                            return WorkoutWidget(workoutModel: workout, mini: false,);
                          },
                        );
                      } else {
                        return Center(
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
