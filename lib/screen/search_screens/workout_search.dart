import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutSearch extends ConsumerWidget {
  const WorkoutSearch({Key? key, this.selection = false, this.day = 0})
      : super(key: key);
  final bool selection;
  final int day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CollectionReference workouts =
        FirebaseFirestore.instance.collection("workout_templates_demo");
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
                    stream: workouts
                        .where("workoutName", isGreaterThan: st.trim())
                        .where("workoutName",
                            isLessThanOrEqualTo: "${st.trim()}\uf7ff").limit(5)
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
                            return WorkoutWidget(
                              workoutModel: workout,
                              mini: false,
                              day: day,
                              selection: selection,
                            );
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
