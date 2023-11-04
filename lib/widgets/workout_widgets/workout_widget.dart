import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:flutter/material.dart';

class WorkoutWidget extends StatelessWidget {
  const WorkoutWidget({Key? key, required this.workoutModel}) : super(key: key);
  final WorkoutModel workoutModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2)),
        // height: 500,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(workoutModel.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    final thisUser = UserServices().mapSingleUser(data);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MiniProfie(user: thisUser),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox(
                        height: 50,
                        child: Text(
                          'loading...',
                        ));
                  } else {
                    return const Text('Error Loading');
                  }
                },
              ),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: workoutModel.categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: PillWidget(
                          editable: false,
                          name: workoutModel.categories[index],
                          delete: () {
                            
                          },
                          active: false),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          workoutModel.workoutName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ImageWidget(url: workoutModel.imageUrl),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
