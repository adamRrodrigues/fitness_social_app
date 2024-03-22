import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/user_stats.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserStatsScreen extends ConsumerStatefulWidget {
  const UserStatsScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _UserStatsScreenState createState() => _UserStatsScreenState();
}

class _UserStatsScreenState extends ConsumerState<UserStatsScreen> {
  CollectionReference userStats =
      FirebaseFirestore.instance.collection('user_stats');

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    User? user = ref.read(userProvider);
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
            // physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title: Text(
                        user.uid == widget.uid ? "My Stats" : "username Stats"),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  )
                ],
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: StreamBuilder(
                  stream: userStats.doc(user!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      final data = snapshot.data!;
                      final thisUserStat = UserStats(
                          uid: widget.uid,
                          userWeight: data['userWeight'],
                          userHeight: data['userHeight'],
                          steps: data['steps'],
                          workoutStreak: data['workoutStreak'],
                          achievements: List.from(data['achievements']));

                      weightController.text =
                          thisUserStat.userWeight.toString();
                      heightController.text =
                          thisUserStat.userHeight.toString();
                      return Column(
                        children: [
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Weight"),
                              ),
                              CustomTextField(
                                textController: weightController,
                                hintText: "Your Weight",
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Height"),
                              ),
                              TextField(
                                controller: heightController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    
                                  )
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )),
      ),
    );
  }
}
